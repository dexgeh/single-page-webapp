window.App = App = {}

Layout = React.createClass
  render : ->
    body =
      `
      <div className="wrapper">
        <div className="header">
          <ul className="horizontal-list">
            <li><a href="/">Index</a></li>
            <li><a href="/about">about</a></li>
          </ul>
        </div>
        <div className="message">{App.message}</div>
        <div className="content">{this.props.children}</div>
      </div>
      `
    delete App.message
    body

renderLayout = (child) ->
  React.renderComponent `<Layout>{child}</Layout>`, document.body

renderLayoutFn = (childFn) -> -> renderLayout childFn()

Index = React.createClass
  render: -> `<p>hello world!</p>`

About = React.createClass
  render: -> `<p>about</p>`

NotFound = React.createClass
  render: -> `<p>file or resource not found</p>`

Actions =
  index : renderLayoutFn Index
  about : renderLayoutFn About
  notFound : renderLayoutFn NotFound

window.onload = ->
  if not window.history and not window.history.popState
    alert "unsupported browser"
    throw new Error
  App.message = init.message
  delete init.message
  page '/', Actions.index
  page '/about', Actions.about
  page '*', Actions.notFound
  page()

