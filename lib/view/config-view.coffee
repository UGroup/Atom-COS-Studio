{View, EditorView, PackageManager} = require 'atom'

StudioAPI= require 'StudioAPI'
fs= require 'fsplus'
module.exports =
class ConfigView extends View
  @content: ->
      @div class: 'cache-modal-dialog overlay from-top', =>
        @div class: "panel", =>
          @h1 "Config", class: "panel-heading"
        @div class: 'block', =>
          @label 'Url to connect'
          @subview 'UrlToConnect', new EditorView(mini:true, placeholderText: 'Example: http://localhost:57772/mdg-dev/')
          @label 'Temp Dir'
          @subview 'TempDir', new EditorView(mini:true, placeholderText: 'Example: C:/temp/')
        @div class: 'block', =>
          @div class: 'btn-group', =>
            @button "OK", outlet:'OKButton', class:'btn'
            @button "Cancel", outlet:'CancelButton', class:'btn'
  initialize:  ->


    @configs = fs.readJSON(atom.packages.resolvePackagePath('cache-studio')+'/lib/configs.json');
    @UrlToConnect.getEditor().setText(@configs.UrlToConnect)
    @TempDir.getEditor().setText(@configs.TempDir)
    p =
      'UrlToConnect':@UrlToConnect
      'TempDir':@TempDir
    @bind(p)
  serialize: ->
  destroy: ->
    @detach()
  toggle: ->
    if @hasParent()
      @detach()
    else
      atom.workspaceView.append(this)
  # Buttons events
  bind: (p) ->
    @OKButton.on 'click', ->
      configs = fs.readJSON(atom.packages.resolvePackagePath('cache-studio')+'/lib/configs.json');
      configs.UrlToConnect = p.UrlToConnect.getEditor().getText()
      configs.TempDir = p.TempDir.getEditor().getText()
      fs.writeJSON(atom.packages.resolvePackagePath('cache-studio')+'/lib/configs.json', configs);
  success: (call) ->
    @OKButton.on 'click', (e)->
      call(e)
    @CancelButton.on 'click', (e)->
      call(e)