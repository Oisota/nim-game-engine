import sdl2

const WINDOW_WIDTH = 800
const WINDOW_HEIGHT = 600

type
  GameScene = ref object of RootObj
    next: GameScene

method init(this: GameScene): void {.base.} =
  quit "Override plz"

method events(this: GameScene): void {.base.} =
  quit "Override plz"

method update(this: GameScene): void {.base.} =
  quit "Override plz"

method render(this: GameScene, render: RendererPtr): void {.base.} =
  quit "Override plz"

type
  GameRect = object
    x, y, w, h, vx, vy: int

proc update(r: var GameRect) =
  r.x += r.vx
  if r.x < 0:
    r.x = 0
    r.vx *= -1
  elif r.x + r.w > WINDOW_WIDTH:
    r.x = WINDOW_WIDTH - 100
    r.vx *= -1

  r.y += r.vy
  if r.y < 0:
    r.y = 0
    r.vy *= -1
  elif r.y + r.h > WINDOW_HEIGHT:
    r.y = WINDOW_HEIGHT - 100
    r.vy *= -1

proc get_rect(r: GameRect): sdl2.Rect =
  result = sdl2.rect(
    x = cint(r.x),
    y = cint(r.y),
    w = cint(r.w),
    h = cint(r.h)
  )

proc main =
  discard sdl2.init(INIT_EVERYTHING)

  var
    window: WindowPtr
    render: RendererPtr
    my_rect = GameRect(
      x: 100,
      y: 100,
      w: 100,
      h: 100,
      vx: 5,
      vy: 5,
    )

  window = createWindow(
    title = "SDL Skeleton",
    x = SDL_WINDOWPOS_CENTERED,
    y = SDL_WINDOWPOS_CENTERED,
    w = WINDOW_WIDTH,
    h = WINDOW_HEIGHT,
    flags = SDL_WINDOW_SHOWN
    )
  render = createRenderer(
    window = window, 
    index = -1,
    flags = Renderer_Accelerated or Renderer_PresentVsync or Renderer_TargetTexture
    )

  var
    evt = sdl2.defaultEvent
    runGame = true

  while runGame:
    while pollEvent(evt):
      case evt.kind
      of QuitEvent:
        runGame = false
        break
      else:
        discard

    my_rect.update()

    render.setDrawColor(0, 0, 0, 255)
    render.clear

    var
      sdl_rect = my_rect.get_rect()

    render.setDrawColor(255, 0, 0, 255)
    render.fillRect(sdl_rect)

    render.present

  destroy render
  destroy window

when isMainModule:
  main()