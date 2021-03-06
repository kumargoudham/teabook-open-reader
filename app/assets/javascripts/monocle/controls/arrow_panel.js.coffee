# Copyright (C) 2012  TEA, the ebook alternative <http://www.tea-ebook.com/>
# 
# This file is part of TeaBook Open Reader
# 
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, version 3.0 of the License.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
# 
# An additional permission has been granted as a special exception 
# to the GNU General Public Licence. 
# You should have received a copy of this exception. If not, see 
# <https://github.com/TEA-ebook/teabook-open-reader/blob/master/GPL-3-EXCEPTION>.



App.Controls.ArrowPanel = (direction) ->
  createControlElements = (cntr) ->
    p.div = cntr.dom.make("div", k.CLS.panel)
    p.arrow = p.div.dom.append("div", k.CLS.arrow)
    p.arrow.dom.addClass direction
    p.arrow.dom.setStyles k.DEFAULT_STYLES.arrow[direction]
    p.div.dom.setStyles k.DEFAULT_STYLES.panel
    Monocle.Events.listenForContact p.div,
      start: start
      move: move
      end: end
      cancel: cancel
    ,
      useCapture: false
    p.div

  listenTo = (evtCallbacks) ->
    p.evtCallbacks = evtCallbacks

  deafen = ->
    p.evtCallbacks = {}

  start = (evt) ->
    p.contact = true
    evt.m.offsetX += p.div.offsetLeft
    evt.m.offsetY += p.div.offsetTop
    expand()
    invoke "start", evt

  move = (evt) ->
    return  unless p.contact
    invoke "move", evt

  end = (evt) ->
    return  unless p.contact
    Monocle.Events.deafenForContact p.div, p.listeners
    contract()
    p.contact = false
    invoke "end", evt

  cancel = (evt) ->
    return  unless p.contact
    Monocle.Events.deafenForContact p.div, p.listeners
    contract()
    p.contact = false
    invoke "cancel", evt

  invoke = (evtType, evt) ->
    p.evtCallbacks[evtType] API, evt.m.offsetX, evt.m.offsetY  if p.evtCallbacks[evtType]
    evt.preventDefault()

  expand = ->
    return  if p.expanded
    p.div.dom.addClass k.CLS.expanded
    p.expanded = true

  contract = (evt) ->
    return  unless p.expanded
    p.div.dom.removeClass k.CLS.expanded
    p.expanded = false

  API = constructor: App.Controls.ArrowPanel
  k = API.constants = API.constructor
  p = API.properties = evtCallbacks: {}
  API.createControlElements = createControlElements
  API.listenTo = listenTo
  API.deafen = deafen
  API.expand = expand
  API.contract = contract
  API

App.Controls.ArrowPanel.CLS =
  panel: "panel"
  expanded: "controls_panel_expanded"
  arrow: "arrow"

App.Controls.ArrowPanel.DEFAULT_STYLES =
  panel:
    position: "absolute"
    height: "100%"
  arrow:
    forwards:
      position: "absolute"
      height: "80px"
      width: "50px"
      top: "50%"
      left: "100%"
    backwards:
      position: "absolute"
      height: "80px"
      width: "50px"
      top: "50%"
      right: "100%"

Monocle.pieceLoaded "controls/arrow_panel"
