###
MouseTrack
To check:
  [ ] remove pointer-events none in existing element?
  [ ] manage SVG
  [ ] what about thing dissapearing on hover out
  [ ] layers
  [ ] iframes
###

class Inspector

  options:
    el            : document.querySelector("html")
    scopeElement  : "inspector-ongoing"
    activeElement : "inspector-active"
    styles        : """<style data-lib="mousetrack" type='text/css'>
    .inspector-ongoing * {
      cursor: crosshair !important;
    }
    .inspector-active {
      /*pointer-events: none;*/
      background-color: lightcoral !important;
      color: white !important;
    }
    .inspector-marker {
      position     : absolute;
      background   : red;
      z-index      : 10000;
      border-radius: 10px;
      width        : 20px;
      height       : 20px;
    }
    </style>
    """

  constructor: (params={})->
    _.extend(@options, params)
    @$el = $(@options.el)
    $(@options.styles).appendTo("head")
    @

  start : ->
    @$el
    .addClass @options.scopeElement
    .on "mousemove", _.bind(@onMouseMove, @)
    .on "click", _.bind(@onClick, @)
    @

  stop : ->
    # todo make sure the unbind happens on the mousemove
    @$el
    .off "mousemove"
    .off "click"
    .removeClass @options.scopeElement
    .find(".#{@options.activeElement}").removeClass(@options.activeElement)
    @

  onMouseMove : _.throttle (e)->
      e.preventDefault()
      e.stopPropagation()

      x = e.clientX
      y = e.clientY
      $hovered = $(document.elementFromPoint(x, y))

      if !$hovered? or $hovered.hasClass(@options.activeElement)
        return

      $hovered.addClass(@options.activeElement)
      $hovered.one "mouseout", (e)=>
        $(e.target).removeClass(@options.activeElement)

      @process($hovered)
    , 200

  onClick: (e)->
    $target = $(e.target)
    position = $target.css("position")
    if position is "static"
      $target.css("position", "relative")

    $("<div class='inspector-marker'></div>")
    .css(
      left: parseFloat(e.clientX) - 10
      top: parseFloat(e.clientY) - 10
    )
    .appendTo($target)

  process: ($el)->
    # console.log "process", $el

window.Inspector = new Inspector()
