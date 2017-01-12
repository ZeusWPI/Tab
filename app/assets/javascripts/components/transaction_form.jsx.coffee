{ button, div, h3, input, option, select } = React.DOM

Action = React.createFactory React.createClass
  buttonClass: (b) ->
    { giving }  = @props
    c = ['btn', 'btn-default']
    c.push 'active' if b == giving
    c.join ' '
  onClick: (b) ->
    =>
      @props.setAction b
  render: ->
    { giving } = @props
    div className: 'btn-group btn-group-lg',
      button type: 'button', className: @buttonClass(true),  onClick: @onClick(true),
        'Give Money'
      button type: 'button', className: @buttonClass(false), onClick: @onClick(false),
        'Request Money'

Amount = React.createFactory React.createClass
  onChange: (ref) ->
    @props.setAmount ref.target.value
  format: (ref) ->
    t = ref.target
    t.value = parseFloat(t.value).toFixed(2)
  render: ->
    div className: 'row',
      div className: 'col-xs-4',
        div className: 'input-group',
          div className: 'input-group-addon', '€'
          input {
            type: 'number',
            className: 'form-control input-lg',
            placeholder: '0.00',
            onChange: @onChange,
            onBlur: @format
          }

Suggestions = React.createFactory React.createClass
  render: ->

Peer = React.createFactory React.createClass
  onChange: (ref) ->
    @props.setPeer ref.target.value
  options: ->
    { peer, peers } = @props
    if peer == '' or peers.includes(peer)
      []
    else
      re = new RegExp peer
      peers.filter (s) ->
        s.match(re) != null
  inputClass: (n) ->
    c = ['form-control', 'input-lg']
    c.push 'active' if n > 0
    c.join ' '
  setPeer: (p) ->
    =>
      @props.setPeer p
  render: ->
    options = @options()
    div className: 'row',
      div className: 'col-xs-4',
        div className: 'suggestions-wrapper',
          input type: 'text', className: @inputClass(options.length), onChange: @onChange, placeholder: 'Zeus member', value: (@props.peer || '')
          if options.length != 0
            div className: 'suggestions',
              @options().map (s, i) =>
                div className: 'suggestion', key: i, onClick: @setPeer(s),
                  s

Message = React.createFactory React.createClass
  onChange: (ref) ->
    @props.setMessage ref.target.value
  render: ->
    div className: 'row',
      div className: 'col-xs-8',
        input type: 'text', className: 'form-control input-lg', onChange: @onChange, placeholder: 'Message'

Submit = React.createFactory React.createClass
  render: ->
    div className: 'row',
      div className: 'col-xs-4 col-xs-offset-4',
        button type: 'submit', onClick: @props.onClick, className: 'btn btn-default btn-lg form-control', 'Confirm'

Step = React.createFactory React.createClass
  render: ->
    div className: 'form-step',
      div className: 'form-step-counter', @props.step
      div className: 'form-step-content',
        div className: 'form-step-title', @props.title
        div className: 'clear-both'
        @props.children
      div className: 'clear-both'

@TransactionForm = React.createClass
  getInitialState: ->
    giving: null, amount: null, peer: null, message: null
  setAction: (b) ->
    @setState giving: b
  setAmount: (a) ->
    @setState amount: a
  setPeer: (p) ->
    @setState peer: p
  setMessage: (m) ->
    @setState message: m
  submit: (e) ->
    console.log 'submit'
  render: ->
    { amount, giving, message, peer } = @state
    { peers }                         = @props
    div id: 'transaction-form',
      h3 null, 'Transfer some money'
      Step step: 1, title: 'What do you want to do?',
        Action giving: giving, setAction: @setAction
      if giving != null
        Step step: 2, title: 'How much do you want to give?',
          Amount setAmount: @setAmount
      if amount != null
        Step step: 3, title: 'Who do you want to give it to?',
          Peer peer: peer, peers: peers, setPeer: @setPeer
      if peer != null
        Step step: 4, title: 'Why do you want to give this?',
          Message setMessage: @setMessage
      if message != null
        Submit null
      div className: 'clear-both'
