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

proc main =
  discard sdl2.init(INIT_EVERYTHING)

  var
    window: WindowPtr
    render: RendererPtr

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
    x_incr = 5
    rect_x = 100

  while runGame:
    while pollEvent(evt):
      case evt.kind
      of QuitEvent:
        runGame = false
        break
      else:
        discard

    rect_x = rect_x + x_incr

    if rect_x < 0:
      rect_x = 0
      x_incr *= -1
    elif rect_x + 100 > WINDOW_WIDTH:
      rect_x = WINDOW_WIDTH - 100
      x_incr *= -1
    render.setDrawColor(0, 0, 0, 255)
    render.clear

    var
      my_rect = sdl2.rect(
        x = cint(rect_x),
        y = cint(100),
        w = cint(100),
        h = cint(100),
      )
    render.setDrawColor(255, 0, 0, 255)
    render.fillRect(my_rect)

    render.present

  destroy render
  destroy window

when isMainModule:
  main()