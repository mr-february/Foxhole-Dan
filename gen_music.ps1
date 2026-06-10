$baseDir = "C:\Users\avkov\GameMakerProjects\Foxhole-Dan\sounds"
$sr  = 44100
$pi2 = [Math]::PI * 2.0
$rng = New-Object System.Random(7)

# ── Note frequencies ─────────────────────────────────────────
$A2=110.0;$B2=123.47;$C3=130.81;$D3=146.83;$E3=164.81;$F3=174.61;$Fs3=185.0
$G3=196.0;$Gs3=207.65;$A3=220.0;$Bb3=233.08;$B3=246.94
$C4=261.63;$Cs4=277.18;$D4=293.66;$Ds4=311.13;$E4=329.63;$F4=349.23
$Fs4=370.0;$G4=392.0;$Gs4=415.3;$A4=440.0;$Bb4=466.16;$B4=493.88
$C5=523.25;$D5=587.33;$E5=659.25;$G5=784.0
$R=0.0  # rest

# ── WAV writer ────────────────────────────────────────────────
function Save-Wav([string]$name,[int16[]]$pcm){
    $n=$pcm.Length;$ds=$n*2;$fs=36+$ds
    $h=[byte[]]::new(44)
    $h[0]=82;$h[1]=73;$h[2]=70;$h[3]=70
    $h[4]=[byte]($fs-band 255);$h[5]=[byte](($fs-shr 8)-band 255)
    $h[6]=[byte](($fs-shr 16)-band 255);$h[7]=[byte](($fs-shr 24)-band 255)
    $h[8]=87;$h[9]=65;$h[10]=86;$h[11]=69
    $h[12]=102;$h[13]=109;$h[14]=116;$h[15]=32
    $h[16]=16;$h[20]=1;$h[22]=1
    $h[24]=68;$h[25]=172;$h[28]=136;$h[29]=88;$h[30]=1;$h[32]=2;$h[34]=16
    $h[36]=100;$h[37]=97;$h[38]=116;$h[39]=97
    $h[40]=[byte]($ds-band 255);$h[41]=[byte](($ds-shr 8)-band 255)
    $h[42]=[byte](($ds-shr 16)-band 255);$h[43]=[byte](($ds-shr 24)-band 255)
    $b=[byte[]]::new($ds);[System.Buffer]::BlockCopy($pcm,0,$b,0,$ds)
    [System.IO.File]::WriteAllBytes("$baseDir\$name\$name.wav",($h+$b))
    Write-Host "  $name  $([Math]::Round(($ds+44)/1024)) KB"
}

# ── Main renderer ─────────────────────────────────────────────
# FM synthesis lead: out = sin(carrier_ph + fm_idx * sin(mod_ph))
# Sawtooth bass, sine chord pad, pitch-sweep kick, noise snare, echo reverb
function Render-Track {
    param(
        [double[]]$mf,                    # melody frequencies
        [double[]]$mb,                    # melody beat durations
        [double[]]$bf,                    # bass frequencies
        [double[]]$bb,                    # bass beat durations
        [double[]]$pad,                   # chord pad tones (3 values)
        [double]$bpm,
        [double]$fm_ratio = 2.0,          # modulator = carrier * fm_ratio
        [double]$fm_idx   = 3.0,          # FM modulation depth
        [double]$vmel = 0.36,
        [double]$vbas = 0.22,
        [double]$vpad = 0.14,
        [int[]]$kpat  = @(1,0,0,0,1,0,0,0),
        [int[]]$spat  = @(0,0,0,0,0,0,0,0),
        [int[]]$hpat  = @(0),
        [bool]$drums  = $true,
        [double]$echo_ms = 220.0         # echo delay in ms (0 = off)
    )

    $beat_n = [int](60.0/$bpm*$sr)
    $loop_beats=0; foreach($b in $mb){$loop_beats+=$b}
    $n=[int]($loop_beats*$beat_n)
    $buf=[double[]]::new($n)   # mix into double for normalisation

    # Melody state
    $mi=0; $mrem=[int]($mb[0]*$beat_n); $mlen=$mrem
    $cph=0.0; $mph=0.0          # carrier / modulator phase

    # Bass state
    $bi=0; $brem=[int]($bb[0]*$beat_n); $bph=0.0

    # Chord pad (3 slightly-detuned sine voices, slow attack)
    $pp=@(0.0,0.0,0.0); $penv=0.0; $patt=1.0/([int]($sr*0.6))

    # Drums
    $kenv=0.0; $kph=0.0          # kick: pitch-sweep sine
    $senv=0.0; $sph=0.0          # snare: noise + sine body
    $henv=0.0                    # hi-hat: very short noise
    $bcnt=0; $brem2=$beat_n

    # Echo delay
    $echo_on=$false; $elen=0; $ebuf=$null; $eptr=0
    if($echo_ms -gt 0){
        $echo_on=$true
        $elen=[int]($sr*$echo_ms/1000.0)
        $ebuf=[double[]]::new($elen)
    }

    for($i=0;$i -lt $n;$i++){
        $t=[double]$i/$sr

        # ── beat boundary ──────────────────────────────────────
        if($brem2 -le 0){
            $brem2=$beat_n
            if($drums){
                if($kpat[$bcnt % $kpat.Length]){$kenv=1.0;$kph=0.0}
                if($spat[$bcnt % $spat.Length]){$senv=1.0;$sph=0.0}
                if($hpat[$bcnt % $hpat.Length]){$henv=1.0}
            }
            $bcnt++
        }
        $brem2--

        # ── melody note advance ────────────────────────────────
        $mrem--
        if($mrem -le 0){
            $mi=($mi+1) % $mf.Length
            $mlen=[int]($mb[$mi]*$beat_n)
            $mrem=$mlen
            $cph=0.0;$mph=0.0
        }

        # ── bass note advance ──────────────────────────────────
        $brem--
        if($brem -le 0){
            $bi=($bi+1) % $bf.Length
            $brem=[int]($bb[$bi]*$beat_n)
            $bph=0.0
        }

        # ── FM lead melody ─────────────────────────────────────
        $mel_v=0.0
        $cf=$mf[$mi]
        if($cf -gt 0){
            $vib=1.0+0.004*[Math]::Sin($pi2*5.5*$t)
            $mph+=($cf*$fm_ratio*$vib)/$sr; if($mph -ge 1.0){$mph-=1.0}
            $cph+=($cf*$vib)/$sr;           if($cph -ge 1.0){$cph-=1.0}
            $fm_sig=$fm_idx*[Math]::Sin($pi2*$mph)
            $mel_v=[Math]::Sin($pi2*$cph+$fm_sig)
            # note envelope: short fade in/out
            $pos=$mlen-$mrem; $fade=400
            $env=1.0
            if($pos -lt $fade){$env=$pos/$fade}
            if($mrem -lt $fade){if($mrem/$fade -lt $env){$env=$mrem/$fade}}
            $mel_v*=$env*$vmel
        }

        # ── sawtooth bass ──────────────────────────────────────
        $bas_v=0.0
        $bcf=$bf[$bi]
        if($bcf -gt 0){
            $bph+=($bcf/$sr); if($bph -ge 1.0){$bph-=1.0}
            $bas_v=($bph*2.0-1.0)*$vbas
        }

        # ── chord pad (3 detuned sine voices, slow attack) ─────
        $pad_v=0.0
        if($null -ne $pad -and $pad.Length -ge 3){
            $penv+=$patt; if($penv -gt 1.0){$penv=1.0}
            for($pi=0;$pi -lt 3;$pi++){
                $det=1.0+($pi-1)*0.003
                $pp[$pi]+=$pad[$pi]*$det/$sr
                if($pp[$pi] -ge 1.0){$pp[$pi]-=1.0}
                $pad_v+=[Math]::Sin($pi2*$pp[$pi])
            }
            $pad_v*=$vpad*$penv/3.0
        }

        # ── kick drum (pitch-sweep sine) ───────────────────────
        $kick_v=0.0
        if($kenv -gt 0.002){
            $kf=55.0+260.0*$kenv           # sweeps 315Hz→55Hz
            $kph+=$kf/$sr
            $kick_v=[Math]::Sin($pi2*$kph)*$kenv*0.48
            $kenv*=0.988
        }

        # ── snare (white noise + 185Hz body) ──────────────────
        $snare_v=0.0
        if($senv -gt 0.002){
            $sph+=185.0/$sr
            $snare_v=$senv*(($rng.NextDouble()*2-1)*0.30+[Math]::Sin($pi2*$sph)*0.14)
            $senv*=0.974
        }

        # ── hi-hat (very short noise) ──────────────────────────
        $hihat_v=0.0
        if($henv -gt 0.002){
            $hihat_v=$henv*($rng.NextDouble()*2-1)*0.10
            $henv*=0.935
        }

        # ── mix ────────────────────────────────────────────────
        $v=$mel_v+$bas_v+$pad_v+$kick_v+$snare_v+$hihat_v

        # ── echo/reverb ────────────────────────────────────────
        if($echo_on){
            $ev=$ebuf[$eptr]
            $ebuf[$eptr]=$v+$ev*0.30      # 30% feedback
            $eptr=($eptr+1) % $elen
            $v=$v*0.78+$ev*0.22
        }

        $buf[$i]=$v
    }

    # ── normalise ──────────────────────────────────────────────
    $peak=0.0
    foreach($s in $buf){$a=[Math]::Abs($s);if($a -gt $peak){$peak=$a}}
    if($peak -lt 0.001){$peak=0.001}
    $scale=0.92/$peak

    $pcm=[int16[]]::new($n)
    for($i=0;$i -lt $n;$i++){
        $v=$buf[$i]*$scale
        if($v -gt 1.0){$v=1.0}elseif($v -lt -1.0){$v=-1.0}
        $pcm[$i]=[int16]([Math]::Round($v*32767))
    }
    return $pcm
}

Write-Host "Generating music (FM synthesis + reverb)..."

# ════════════════════════════════════════════════════════════
# snd_music_title  80 BPM  A-minor  warm FM (ratio 1, idx 2.5)
#   Slow, melancholy. Chord pad with slow attack under the melody.
# ════════════════════════════════════════════════════════════
$pcm = Render-Track `
    -mf @($A4, $G4, $E4, $D4, $E4, $C4, $D4, $A3) `
    -mb @(2.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 8.0) `
    -bf @($A2,       $E3,       $A2,       $C3      ) `
    -bb @(4.0,       4.0,       4.0,       4.0      ) `
    -pad @($A3,$C4,$E4) `
    -bpm 80 -fm_ratio 1.0 -fm_idx 2.5 `
    -vmel 0.38 -vbas 0.16 -vpad 0.16 `
    -kpat @(1,0,0,0,0,0,0,0) `
    -spat @(0) -hpat @(0) -drums $true -echo_ms 280
Save-Wav "snd_music_title" $pcm

# ════════════════════════════════════════════════════════════
# snd_music_room1  160 BPM  E-minor  sharp FM (ratio 2, idx 5)
#   Aggressive riff. Full drums. Fast and punchy.
# ════════════════════════════════════════════════════════════
$pcm = Render-Track `
    -mf @($E4, $E4, $B4, $A4, $G4, $E4, $D4, $E4) `
    -mb @(0.5, 0.5, 1.0, 0.5, 0.5, 1.0, 1.0, 3.0) `
    -bf @($E3,  $G3,  $A3,  $B3 ) `
    -bb @(2.0,  2.0,  2.0,  2.0 ) `
    -pad @($E3,$G3,$B3) `
    -bpm 160 -fm_ratio 2.0 -fm_idx 5.0 `
    -vmel 0.40 -vbas 0.24 -vpad 0.10 `
    -kpat @(1,0,1,0,1,0,1,0) `
    -spat @(0,0,1,0,0,0,1,0) `
    -hpat @(1,0,1,0,1,0,1,0) `
    -drums $true -echo_ms 110
Save-Wav "snd_music_room1" $pcm

# ════════════════════════════════════════════════════════════
# snd_music_room2  128 BPM  G-major  brass FM (ratio 1.5, idx 3)
#   Military march. Dotted rhythm. Heroic feel.
# ════════════════════════════════════════════════════════════
$pcm = Render-Track `
    -mf @($G4, $G4, $A4, $B4, $D5, $D5, $B4, $G4) `
    -mb @(1.5, 0.5, 1.0, 1.0, 1.5, 0.5, 1.0, 1.0) `
    -bf @($G3,  $D3,  $C3,  $G3,  $D3 ) `
    -bb @(2.0,  2.0,  2.0,  2.0,  2.0 ) `
    -pad @($G3,$B3,$D4) `
    -bpm 128 -fm_ratio 1.5 -fm_idx 3.0 `
    -vmel 0.38 -vbas 0.22 -vpad 0.14 `
    -kpat @(1,0,0,0,1,0,0,0,1,0,0,0) `
    -spat @(0,0,0,1,0,0,0,0,0,0,0,1) `
    -hpat @(1,0,1,0,1,0,1,0,1,0,1,0) `
    -drums $true -echo_ms 150
Save-Wav "snd_music_room2" $pcm

# ════════════════════════════════════════════════════════════
# snd_music_room3  100 BPM  D-minor  organ FM (ratio 1, idx 4)
#   Tense vertical climb. Ascending motif, syncopated kick.
# ════════════════════════════════════════════════════════════
$pcm = Render-Track `
    -mf @($D4, $F4, $G4, $A4, $C5, $A4, $G4, $F4) `
    -mb @(2.0, 1.0, 1.0, 2.0, 1.0, 1.0, 1.0, 3.0) `
    -bf @($D3,  $C3,  $F3,  $A3 ) `
    -bb @(3.0,  3.0,  3.0,  3.0 ) `
    -pad @($D3,$F3,$A3) `
    -bpm 100 -fm_ratio 1.0 -fm_idx 4.0 `
    -vmel 0.38 -vbas 0.20 -vpad 0.15 `
    -kpat @(1,0,0,1,0,0,1,0,0,0) `
    -spat @(0,0,1,0,0,1,0,0,1,0) `
    -hpat @(0) `
    -drums $true -echo_ms 200
Save-Wav "snd_music_room3" $pcm

# ════════════════════════════════════════════════════════════
# snd_music_room4  175 BPM  E-minor  harsh FM (ratio 2, idx 7)
#   URGENT countdown. Maximum aggression. Snare on every offbeat.
# ════════════════════════════════════════════════════════════
$pcm = Render-Track `
    -mf @($E4, $Fs4,$G4, $A4, $B4, $A4, $Gs4,$E4) `
    -mb @(1.0, 1.0, 1.0, 1.0, 2.0, 1.0, 1.0, 8.0) `
    -bf @($E3,  $A3,  $B3,  $A3 ) `
    -bb @(2.0,  2.0,  2.0,  2.0 ) `
    -pad @($E3,$G3,$B3) `
    -bpm 175 -fm_ratio 2.0 -fm_idx 7.0 `
    -vmel 0.42 -vbas 0.25 -vpad 0.08 `
    -kpat @(1,1,1,1,1,1,1,1) `
    -spat @(0,1,0,1,0,1,0,1) `
    -hpat @(1,0,1,0,1,0,1,0) `
    -drums $true -echo_ms 80
Save-Wav "snd_music_room4" $pcm

# ════════════════════════════════════════════════════════════
# snd_music_room5  136 BPM  C-major  full FM (ratio 1, idx 3)
#   Epic tower defense. Triumphant. Full chord pads. Hi-hats.
# ════════════════════════════════════════════════════════════
$pcm = Render-Track `
    -mf @($G4, $E4, $C4, $E4, $G4, $A4, $G4, $E4) `
    -mb @(1.0, 1.0, 2.0, 1.0, 1.0, 1.0, 1.0, 4.0) `
    -bf @($C3,  $G3,  $A3,  $E3,  $F3,  $G3 ) `
    -bb @(2.0,  2.0,  2.0,  2.0,  2.0,  2.0 ) `
    -pad @($C3,$E3,$G3) `
    -bpm 136 -fm_ratio 1.0 -fm_idx 3.0 `
    -vmel 0.40 -vbas 0.22 -vpad 0.18 `
    -kpat @(1,0,0,0,1,0,0,0) `
    -spat @(0,0,1,0,0,0,1,0) `
    -hpat @(1,0,1,0,1,0,1,0) `
    -drums $true -echo_ms 160
Save-Wav "snd_music_room5" $pcm

# ════════════════════════════════════════════════════════════
# snd_music_cutscene  58 BPM  A-minor  warm FM (ratio 0.5, idx 1.5)
#   Somber cinematic. Ratio < 1 = subharmonic = very warm/mellow.
#   Rests (R) for space. No hi-hat. Just slow pads and melody.
# ════════════════════════════════════════════════════════════
$pcm = Render-Track `
    -mf @($A4, $R,   $G4, $F4, $E4, $R,   $E4, $D4) `
    -mb @(3.0, 1.0,  1.5, 1.5, 3.0, 1.0,  1.5, 4.5) `
    -bf @($A2,       $F3,       $C3,       $E3      ) `
    -bb @(4.0,       4.0,       4.0,       4.0      ) `
    -pad @($A3,$C4,$E4) `
    -bpm 58 -fm_ratio 0.5 -fm_idx 1.5 `
    -vmel 0.34 -vbas 0.14 -vpad 0.18 `
    -kpat @(0) -spat @(0) -hpat @(0) `
    -drums $false -echo_ms 350
Save-Wav "snd_music_cutscene" $pcm

# ════════════════════════════════════════════════════════════
# snd_engine  2s drone loop
# ════════════════════════════════════════════════════════════
$n=[int]($sr*2.0); $buf=[double[]]::new($n)
$p1=0.0;$p2=0.0;$p3=0.0
for($i=0;$i -lt $n;$i++){
    $p1+=80.0/$sr;  if($p1 -ge 1.0){$p1-=1.0}
    $p2+=160.0/$sr; if($p2 -ge 1.0){$p2-=1.0}
    $p3+=240.0/$sr; if($p3 -ge 1.0){$p3-=1.0}
    $w=1.0+0.07*[Math]::Sin($pi2*1.5*$i/$sr)
    $buf[$i]=(0.55*($p1*2-1)+0.28*($p2*2-1)+0.17*($p3*2-1))*$w
}
$peak=0.0; foreach($s in $buf){$a=[Math]::Abs($s);if($a -gt $peak){$peak=$a}}
$pcm=[int16[]]::new($n)
for($i=0;$i -lt $n;$i++){
    $v=$buf[$i]*0.68/$peak
    if($v -gt 1.0){$v=1.0}elseif($v -lt -1.0){$v=-1.0}
    $pcm[$i]=[int16]([Math]::Round($v*32767))
}
Save-Wav "snd_engine" $pcm

# ════════════════════════════════════════════════════════════
# snd_vehicle_gun  0.12s punchy shot
# ════════════════════════════════════════════════════════════
$n=[int]($sr*0.12); $pcm=[int16[]]::new($n); $kph2=0.0
for($i=0;$i -lt $n;$i++){
    $t=$i/$sr
    $kph2+=$pi2*120.0/$sr
    $env=[Math]::Exp(-55.0*$t)
    $v=([Math]::Sin($kph2)*0.65+($rng.NextDouble()*2-1)*0.45)*$env*0.92
    if($v -gt 1.0){$v=1.0}elseif($v -lt -1.0){$v=-1.0}
    $pcm[$i]=[int16]([Math]::Round($v*32767))
}
Save-Wav "snd_vehicle_gun" $pcm

Write-Host "Done."
