import std/tables
import system/iterators

import sdl2

const WINDOW_WIDTH = 800
const WINDOW_HEIGHT = 600

type
  ComponentTypes = enum
    CTPosition, CTDraw
  ComponentContext = object
    render: RendererPtr
  Component = ref object of RootObj
    entity: Entity
  Position = ref object of Component
    x, y, w, h, vx, vy: int
  Draw = ref object of Component
    r, g, b, a: uint8

  Entity = object
    id: int
    components: Table[ComponentTypes, Component]

  GameState = object
    entities: seq[Entity]

method process(this: var Component, ctx: ComponentContext): void  {.base.} =
  quit "Override me plz!"

method process(r: var Position, ctx: ComponentContext): void =
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

method get_rect(this: Position): sdl2.Rect =
  result = sdl2.rect(
    x = cint(this.x),
    y = cint(this.y),
    w = cint(this.w),
    h = cint(this.h)
  )

method process(this: var Draw, ctx: ComponentContext): void =
  if not this.entity.components.hasKey(ComponentTypes.CTPosition):
    echo "No Position"
    return

  var
    component = this.entity.components[ComponentTypes.CTPosition]
    pos = Position(component)
    rect = pos.get_rect

  ctx.render.setDrawColor(0, 0, 0, 255)
  ctx.render.clear
  ctx.render.setDrawColor(this.r, this.g, this.b, this.a)
  ctx.render.fill_rect(rect)
  ctx.render.present

proc initEntity(id: int): Entity =
  var components = initTable[ComponentTypes, Component](64)
  result = Entity(id: id, components: components)

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
    state = GameState(entities: @[])
    ctx = ComponentContext(render: render)
    my_entity = initEntity(0)
    pos_comp = Position(x: 100, y: 100, w: 100, h: 100, vx: 5, vy: 5)
    draw_comp = Draw(r: 255, g: 0, b: 0, a: 0)

  my_entity.components[ComponentTypes.CTPosition] = pos_comp
  my_entity.components[ComponentTypes.CTDraw] = draw_comp
  state.entities.add(my_entity)

  while runGame:
    while pollEvent(evt):
      case evt.kind
      of QuitEvent:
        runGame = false
        break
      else:
        discard

      for component_type in iterators.items(ComponentTypes):
        for entity in state.entities:
          var component: Component
          if component_type in entity.components:
            component = entity.components[component_type]
            component.process(ctx)

  destroy render
  destroy window

when isMainModule:
  main()