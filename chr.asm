; asmsyntax=ca65

.segment "CHR00"

;.align $400

;.align $400
;.include "chr_large.i"
.align $1000
.incbin "img/chr/00-machine-gun_large.chr"
.incbin "img/chr/00-machine-gun_small.chr"

; four blank tiles for a blank arrow
.repeat 4
    .repeat 16
        .byte 0
    .endrepeat
.endrepeat

.align $800
.incbin "img/chr/arrow-up.chr"
.incbin "img/chr/arrow-down.chr"
.incbin "img/chr/arrow-left.chr"
.incbin "img/chr/arrow-right.chr"
.incbin "img/chr/font.chr"

.align $1000
.incbin "img/chr/01-anti-material_large.chr"
.incbin "img/chr/01-anti-material_small.chr"
.incbin "img/chr/arrow-up.chr"

.align $800
.incbin "img/chr/arrow-up.chr"
.incbin "img/chr/arrow-down.chr"
.incbin "img/chr/arrow-left.chr"
.incbin "img/chr/arrow-right.chr"
.incbin "img/chr/font_inverted.chr"

.align $1000
.incbin "img/chr/02-stalwart_large.chr"
.incbin "img/chr/02-stalwart_small.chr"
.incbin "img/chr/arrow-down.chr"

.align $1000
.incbin "img/chr/03-expendable-rocket_large.chr"
.incbin "img/chr/03-expendable-rocket_small.chr"
.incbin "img/chr/arrow-left.chr"

.align $1000
.incbin "img/chr/04-recoilless_large.chr"
.incbin "img/chr/04-recoilless_small.chr"
.incbin "img/chr/arrow-right.chr"

.align $1000
.incbin "img/chr/05-flamethrower_large.chr"
.incbin "img/chr/05-flamethrower_small.chr"
.incbin "img/chr/arrow-up-pressed.chr"

.align $1000
.incbin "img/chr/06-autocannon_large.chr"
.incbin "img/chr/06-autocannon_small.chr"
.incbin "img/chr/arrow-down-pressed.chr"

.align $1000
.incbin "img/chr/07-heavy-mg_large.chr"
.incbin "img/chr/07-heavy-mg_small.chr"
.incbin "img/chr/arrow-left-pressed.chr"

.align $1000
.incbin "img/chr/08-airburst_large.chr"
.incbin "img/chr/08-airburst_small.chr"
.incbin "img/chr/arrow-right-pressed.chr"

.align $1000
.incbin "img/chr/09-railgun_large.chr"
.incbin "img/chr/09-railgun_small.chr"

.align $1000
.incbin "img/chr/10-spear_large.chr"
.incbin "img/chr/10-spear_small.chr"
.align $1000
.incbin "img/chr/11-gatling-barrage_large.chr"
.incbin "img/chr/11-gatling-barrage_small.chr"
.align $1000
.incbin "img/chr/12-airburst_large.chr"
.incbin "img/chr/12-airburst_small.chr"
.align $1000
.incbin "img/chr/13-120mm_large.chr"
.incbin "img/chr/13-120mm_small.chr"

.align $1000
.incbin "img/chr/14-380mm_large.chr"
.incbin "img/chr/14-380mm_small.chr"
.align $1000
.incbin "img/chr/15-walking-barrage_large.chr"
.incbin "img/chr/15-walking-barrage_small.chr"
.align $1000
.incbin "img/chr/16-orbital-laser_large.chr"
.incbin "img/chr/16-orbital-laser_small.chr"
.align $1000
.incbin "img/chr/17-orbital-railgun_large.chr"
.incbin "img/chr/17-orbital-railgun_small.chr"
.align $1000
.incbin "img/chr/18-eagle-strafing_large.chr"
.incbin "img/chr/18-eagle-strafing_small.chr"
.align $1000
.incbin "img/chr/19-eagle-airstrike_large.chr"
.incbin "img/chr/19-eagle-airstrike_small.chr"
.align $1000
.incbin "img/chr/20-eagle-clusterbomb_large.chr"
.incbin "img/chr/20-eagle-clusterbomb_small.chr"
.align $1000
.incbin "img/chr/21-eagle-napalm_large.chr"
.incbin "img/chr/21-eagle-napalm_small.chr"
.align $1000
.incbin "img/chr/22-jump-pack_large.chr"
.incbin "img/chr/22-jump-pack_small.chr"
.align $1000
.incbin "img/chr/23-eagle-smoke_large.chr"
.incbin "img/chr/23-eagle-smoke_small.chr"
.align $1000
.incbin "img/chr/24-eagle-110_large.chr"
.incbin "img/chr/24-eagle-110_small.chr"
.align $1000
.incbin "img/chr/25-eagle-500_large.chr"
.incbin "img/chr/25-eagle-500_small.chr"
.align $1000
.incbin "img/chr/26-orbital-precision_large.chr"
.incbin "img/chr/26-orbital-precision_small.chr"
.align $1000
.incbin "img/chr/27-orbital-gas_large.chr"
.incbin "img/chr/27-orbital-gas_small.chr"

.align $1000
.incbin "img/chr/28-orbital-ems_large.chr"
.incbin "img/chr/28-orbital-ems_small.chr"
.align $1000
.incbin "img/chr/29-orbital-smoke_large.chr"
.incbin "img/chr/29-orbital-smoke_small.chr"
.align $1000
.incbin "img/chr/30-emplacement_large.chr"
.incbin "img/chr/30-emplacement_small.chr"
.align $1000
.incbin "img/chr/31-shield-gen_large.chr"
.incbin "img/chr/31-shield-gen_small.chr"
.align $1000
.incbin "img/chr/32-tesla-tower_large.chr"
.incbin "img/chr/32-tesla-tower_small.chr"
.align $1000
.incbin "img/chr/33-mines_large.chr"
.incbin "img/chr/33-mines_small.chr"
.align $1000
.incbin "img/chr/34-supply-pack_large.chr"
.incbin "img/chr/34-supply-pack_small.chr"
.align $1000
.incbin "img/chr/35-grenade-launcher_large.chr"
.incbin "img/chr/35-grenade-launcher_small.chr"
.align $1000
.incbin "img/chr/36-laser-cannon_large.chr"
.incbin "img/chr/36-laser-cannon_small.chr"
.align $1000
.incbin "img/chr/37-fire-mines_large.chr"
.incbin "img/chr/37-fire-mines_small.chr"
.align $1000
.incbin "img/chr/38-guard-dog-rover_large.chr"
.incbin "img/chr/38-guard-dog-rover_small.chr"
.align $1000
.incbin "img/chr/39-ballistic-shield_large.chr"
.incbin "img/chr/39-ballistic-shield_small.chr"
.align $1000
.incbin "img/chr/40-arc-thrower_large.chr"
.incbin "img/chr/40-arc-thrower_small.chr"
.align $1000
.incbin "img/chr/41-quasar-cannon_large.chr"
.incbin "img/chr/41-quasar-cannon_small.chr"

.align $1000
.incbin "img/chr/42-shield-pack_large.chr"
.incbin "img/chr/42-shield-pack_small.chr"
.align $1000
.incbin "img/chr/43-mg-turret_large.chr"
.incbin "img/chr/43-mg-turret_small.chr"
.align $1000
.incbin "img/chr/44-gatling-turret_large.chr"
.incbin "img/chr/44-gatling-turret_small.chr"
.align $1000
.incbin "img/chr/45-mortar_large.chr"
.incbin "img/chr/45-mortar_small.chr"
.align $1000
.incbin "img/chr/46-guard-dog_large.chr"
.incbin "img/chr/46-guard-dog_small.chr"
.align $1000
.incbin "img/chr/47-autocannon-turret_large.chr"
.incbin "img/chr/47-autocannon-turret_small.chr"
.align $1000
.incbin "img/chr/48-rocket-turret_large.chr"
.incbin "img/chr/48-rocket-turret_small.chr"
.align $1000
.incbin "img/chr/49-ems-mortar_large.chr"
.incbin "img/chr/49-ems-mortar_small.chr"
.align $1000
.incbin "img/chr/50-patriot_large.chr"
.incbin "img/chr/50-patriot_small.chr"
.align $1000
.incbin "img/chr/51-reinforce_large.chr"
.incbin "img/chr/51-reinforce_small.chr"
.align $1000
.incbin "img/chr/52-sos_large.chr"
.incbin "img/chr/52-sos_small.chr"
.align $1000
.incbin "img/chr/53-resupply_large.chr"
.incbin "img/chr/53-resupply_small.chr"
.align $1000
.incbin "img/chr/54-eagle-rearm_large.chr"
.incbin "img/chr/54-eagle-rearm_small.chr"
.align $1000
.incbin "img/chr/55-ssd-delivery_large.chr"
.incbin "img/chr/55-ssd-delivery_small.chr"

.align $1000
.incbin "img/chr/56-prospecting-drill_large.chr"
.incbin "img/chr/56-prospecting-drill_small.chr"
.align $1000
.incbin "img/chr/57-flag_large.chr"
.incbin "img/chr/57-flag_small.chr"
.align $1000
.incbin "img/chr/58-hellbomb_large.chr"
.incbin "img/chr/58-hellbomb_small.chr"
.align $1000
.incbin "img/chr/59-upload-data_large.chr"
.incbin "img/chr/59-upload-data_small.chr"
.align $1000
.incbin "img/chr/60-seismic-probe_large.chr"
.incbin "img/chr/60-seismic-probe_small.chr"
.align $1000
.incbin "img/chr/61-illumination_large.chr"
.incbin "img/chr/61-illumination_small.chr"
.align $1000
.incbin "img/chr/62-seaf_large.chr"
.incbin "img/chr/62-seaf_small.chr"

.align $1000
.incbin "img/chr/menu_bg.chr"
