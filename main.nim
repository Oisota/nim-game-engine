import sdl2

const WINDOW_WIDTH = 800
const WINDOW_HEIGHT = 600

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
  render = createRenderer(window, -1, Renderer_Accelerated or Renderer_PresentVsync or Renderer_TargetTexture)

  var
    evt = sdl2.defaultEvent
    runGame = true

  while runGame:
    while pollEvent(evt):
      if evt.kind == QuitEvent:
        runGame = false
        break

    render.setDrawColor(0, 0, 0, 255)
    render.clear
    render.present

  destroy render
  destroy window

when isMainModule:
  main()