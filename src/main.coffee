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
    speed: 350
    minX: 405
    maxX: 790
    minY: 0
    maxY: 285
    color: '#dddd00'
    }
    {
    x: 200
    y: 450
    speed: -150
    minX: 0
    maxX: 385
    minY: 305
    maxY: 590
    color: '#00ff00'
    }
    {
    x: 600
    y: 450
    speed: 50
    minX: 405
    maxX: 790
    minY: 305
    maxY: 590
    color: '#ff00ff'
    }
]

enemies = [[], [], [], []]

toEnemy = 2
toToEnemy = 3

ogre = false

clamp = (v, min, max) ->
    if v < min then min else if v > max then max else v

collides = (a, b, as, bs) ->
    a.x + as > b.x and a.x < b.x + bs and a.y + as > b.y and a.y < b.y + bs

enemyInside = (e, i) ->
    e.x >= players[i].minX + 6 and e.x <= players[i].maxX + 6 and e.y >= players[i].minY + 6 and e.y <= players[i].maxY + 6

spawn = [
    ->
        x = Math.floor(Math.random() * 380)

        x: x
        y: -5
        dx: players[0].x - x
        dy: players[0].y + 5
        speed: speedMod
    ->
        y = Math.floor(Math.random() * 300)

        x: 800
        y: y
        dx: players[1].x - 800
        dy: players[1].y - y
        speed: speedMod
    ->
        x: -5
        y: 605
        dx: players[2].x + 5
        dy: players[2].y - 605
        speed: speedMod
    ->
        x: players[3].x
        y: 600
        dx: 0
        dy: -1
        speed: speedMod / 2
]

speedMod = 60
elapsed = 0

update = ->
    setDelta()

    elapsed += delta
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

    speedMod += delta / 5

    for enemy, i in enemies
        for e in enemy
            e.x += e.dx / Math.sqrt(e.dx * e.dx + e.dy * e.dy) * delta * e.speed
            e.y += e.dy / Math.sqrt(e.dx * e.dx + e.dy * e.dy) * delta * e.speed

            if collides(players[i], e, 10, 6)
                console.log 'VOOOB'
                ogre = true

    toEnemy -= delta
    if toEnemy <= 0
        toToEnemy -= 0.09
        toEnemy = toToEnemy

        r = Math.floor(Math.random() * 4)
        enemies[r].push spawn[r]()

        if elapsed >= 10
            r = if r == 3 then 0 else r + 1
            enemies[r].push spawn[r]()

        if elapsed >= 30
            r = if r == 3 then 0 else r + 1
            enemies[r].push spawn[r]()

        if elapsed >= 50
            r = if r == 3 then 0 else r + 1
            enemies[r].push spawn[r]()

    draw(delta)

    if not ogre

        window.requestAnimationFrame(update)


draw = (delta) ->
    ctx.clearRect(0, 0, c.width, c.height)

    for player in players
        ctx.fillStyle = if ogre then 'rgba(0, 0, 0, 0.5)' else player.color
        ctx.fillRect(player.x, player. y, 10, 10)

    for enemy, i in enemies
        for e in enemy
            ctx.fillStyle = if enemyInside(e, i) then '#444444' else 'rgba(0, 0, 0, 0.1)'
            ctx.fillRect(e.x, e.y, 6, 6)

    ctx.fillStyle = if ogre then 'rgba(0, 0, 0, 0.5)' else'#000000'
    ctx.fillRect(395, 0, 10, 600)
    ctx.fillRect(0, 295, 800, 10)

    ctx.font = '24px Visitor'
    ctx.fillStyle = '#000000'
    ctx.fillText(elapsed.toFixed(2), 20, 20)

    if ogre
        ctx.font = '160px Visitor'
        ctx.textAlign = 'center';
        ctx.textBaseline = 'middle';
        ctx.fillStyle = '#000000'
        ctx.fillText('( ͡° ͜ʖ ͡°)', 400, 300)


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
