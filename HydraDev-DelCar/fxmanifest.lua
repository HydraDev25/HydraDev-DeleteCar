fx_version 'cerulean'
game 'gta5'

author 'z4r3'
description 'Hydra Development Delete Car System. Support: https://discord.gg/H2yp7UUxgq'
version '1.0.0'

shared_scripts {
    '@qb-core/shared/locale.lua',
}

client_scripts {
    'client/car_management.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/car_management.lua',
}

lua54 'yes'

