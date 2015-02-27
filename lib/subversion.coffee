{CompositeDisposable} = require "atom"

Subversion = (args, cwd) ->
  spawn = require("child_process").spawn
  command = atom.config.get("subversion.svnPath") + "/svn"
  options =
    cwd: cwd

  tProc = spawn(command, args, options)

  tProc.stdout.on "data", (data) ->
    console.log "stdout: " + data

  tProc.stderr.on "data", (data) ->
    console.log "stderr: " + data

  tProc.on "close", (code) ->
    console.log "child process exited with code " + code

resolveTreeSelection = ->
  if atom.packages.isPackageLoaded("tree-view")
    treeView = atom.packages.getLoadedPackage("tree-view")
    treeView = require(treeView.mainModulePath)
    serialView = treeView.serialize()
    serialView.selectedPath

resolveEditorFile = ->
  editor = atom.workspace.getActivePaneItem();

  return if !editor

  file = editor.buffer.file;
  return if !file

  file.path

blame = (currFile)->
  args = [
    "/command:blame"
    "/path:"+currFile
    "/startrev:1"
    "/endrev:-1"
  ]
  Subversion(args, path.dirname(currFile))

commit = (currFile)->
  Subversion(["/command:commit", "/path:"+currFile], path.dirname(currFile))

diff = (currFile)->
  Subversion(["/command:diff", "/path:"+currFile], path.dirname(currFile))

log = (currFile)->
  Subversion(["/command:log", "/path:."], path.dirname(currFile))

revert = (currFile)->
  Subversion(["/command:revert", "/path:"+currFile], path.dirname(currFile))

update = (currFile)->
  Subversion(["/command:update", "/path:"+currFile], path.dirname(currFile))

module.exports = Subversion =
  config:
    svnPath:
      title: "Subversion bin path"
      description: "The folder containing Subversion binares"
      type: "string"
      default: "/usr/local/bin"

  activate: (state) ->
    atom.workspaceView.command "subversion:blameFromTreeView", => @blameFromTreeView()
    atom.workspaceView.command "subversion:blameFromEditor", => @blameFromEditor()

    atom.workspaceView.command "subversion:commitFromTreeView", => @commitFromTreeView()
    atom.workspaceView.command "subversion:commitFromEditor", => @commitFromEditor()

    atom.workspaceView.command "subversion:diffFromTreeView", => @diffFromTreeView()
    atom.workspaceView.command "subversion:diffFromEditor", => @diffFromEditor()

    atom.workspaceView.command "subversion:logFromTreeView", => @logFromTreeView()
    atom.workspaceView.command "subversion:logFromEditor", => @logFromEditor()

    atom.workspaceView.command "subversion:revertFromTreeView", => @revertFromTreeView()
    atom.workspaceView.command "subversion:revertFromEditor", => @revertFromEditor()

    atom.workspaceView.command "subversion:updateFromTreeView", => @updateFromTreeView()
    atom.workspaceView.command "subversion:updateFromEditor", => @updateFromEditor()

  blameFromTreeView: ->
    currFile = resolveTreeSelection()
    return if !currFile
    blame(currFile)

  blameFromEditor: ->
    currFile = resolveEditorFile()
    return if !currFile
    blame(currFile)

  commitFromTreeView: ->
    currFile = resolveTreeSelection()
    return if !currFile
    commit(currFile)

  commitFromEditor: ->
    currFile = resolveEditorFile()
    return if !currFile
    commit(currFile)

  diffFromTreeView: ->
    currFile = resolveTreeSelection()
    return if !currFile
    diff(currFile)

  diffFromEditor: ->
    currFile = resolveEditorFile()
    return if !currFile
    diff(currFile)

  logFromTreeView: ->
    currFile = resolveTreeSelection()
    return if !currFile
    log(currFile)

  logFromEditor: ->
    currFile = resolveEditorFile()
    return if !currFile
    log(currFile)

  revertFromTreeView: ->
    currFile = resolveTreeSelection()
    return if !currFile
    revert(currFile)

  revertFromEditor: ->
    currFile = resolveEditorFile()
    return if !currFile
    revert(currFile)

  updateFromTreeView: ->
    currFile = resolveTreeSelection()
    return if !currFile
    update(currFile)

  updateFromEditor: ->
    currFile = resolveEditorFile()
    return if !currFile
    update(currFile)
