c = document.getElementById('draw')
ctx = c.getContext('2d')

delta = 0
now = 0
before = Date.now()


# c.width = window.innerWidth
# c.height = window.innerHeight

c.width = 800
c.height = 600

keysDown = {}


window.addEventListener("keydown", (e) ->
    keysDown[e.keyCode] = true
, false)

window.addEventListener("keyup", (e) ->
    delete keysDown[e.keyCode]
, false)

setDelta = ->
    now = Date.now()
    delta = (now - before) / 1000
    before = now;

players = [{
    x: 200
    y: 150
    speed: 150
    minX: 0
    maxX: 385
    minY: 0
    maxY: 285
    color: '#ff0000'
    }
    {
    x: 600
    y: 150
    speed: 150
    minX: 405
    maxX: 800
    minY: 0
    maxY: 285
    color: '#ffff00'
    }
    {
    x: 200
    y: 450
    speed: 150
    minX: 0
    maxX: 385
    minY: 305
    maxY: 600
    color: '#000000'
    }
    {
    x: 600
    y: 450
    speed: 150
    minX: 405
    maxX: 800
    minY: 305
    maxY: 600
    color: '#ff00ff'
    }
]

clamp = (v, min, max) ->
    if v < min then min else if v > max then max else v

update = ->
    setDelta()

    newPlayers = ({x: p.x, y: p.y} for p in players)


    if keysDown[65]
        for player, i in players
            newPlayers[i].x = player.x - delta * player.speed
    if keysDown[68]
        for player, i in players
            newPlayers[i].x = player.x + delta * player.speed
    if keysDown[87]
        for player, i in players
            newPlayers[i].y = player.y - delta * player.speed
    if keysDown[83]
        for player, i in players
            newPlayers[i].y = player.y + delta * player.speed

    for player, i in players
        player.x = clamp(newPlayers[i].x, player.minX, player.maxX)
        player.y = clamp(newPlayers[i].y, player.minY, player.maxY)

    draw(delta)

    window.requestAnimationFrame(update)


draw = (delta) ->
    ctx.clearRect(0, 0, c.width, c.height)

    for player, i in players
        ctx.fillStyle = player.color
        ctx.fillRect(player.x, player. y, 10, 10)

    ctx.fillStyle = '#000000'
    ctx.fillRect(395, 0, 10, 600)
    ctx.fillRect(0, 295, 800, 10)


do ->
    w = window
    for vendor in ['ms', 'moz', 'webkit', 'o']
        break if w.requestAnimationFrame
        w.requestAnimationFrame = w["#{vendor}RequestAnimationFrame"]

    if not w.requestAnimationFrame
        targetTime = 0
        w.requestAnimationFrame = (callback) ->
            targetTime = Math.max targetTime + 16, currentTime = +new Date
            w.setTimeout (-> callback +new Date), targetTime - currentTime


update()
