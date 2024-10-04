fx_version 'cerulean'
game 'gta5'

author 'Your Name'
description 'インベントリ確認プラグイン - QBCoreを使用してプレイヤーのインベントリ内のアイテム情報を取得し、チャットに表示します。'
version '1.0.0'

shared_scripts {
    '@qb-core/shared/locale.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server.lua'
}

dependencies {
    'qb-core'
}

lua54 'yes'