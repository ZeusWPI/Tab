{ button, div, form, h3, input, option, select } = React.DOM

url = (path) ->
  "#{window.base_url || ''}/#{path}"

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
    t.value = parseFloat(t.value).toFixed(2) if t.value
  render: ->
    div className: 'row',
      div className: 'col-xs-8',
        div className: 'input-group',
          div className: 'input-group-addon', '€'
          input {
            className: 'form-control input-lg',
            name: 'transaction[euros]'
            onBlur: @format,
            onChange: @onChange,
            placeholder: '0.00',
            type: 'number',
          }

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
      div className: 'col-xs-8',
        div className: 'suggestions-wrapper',
          input {
            className: @inputClass(options.length),
            onChange: @onChange,
            placeholder: 'Zeus member',
            type: 'text',
            value: (@props.peer || '')
          }
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
        input {
          className: 'form-control input-lg',
          name: 'transaction[message]',
          onChange: @onChange,
          placeholder: 'Message'
          type: 'text',
        }

Submit = React.createFactory React.createClass
  render: ->
    { onClick } = @props
    div className: 'row',
      div className: 'col-xs-4 col-xs-offset-4',
        button {
          className: 'btn btn-default btn-lg btn-block',
          onClick: onClick,
          type: 'submit',
        }, 'Confirm'

Step = React.createFactory React.createClass
  render: ->
    { error } = @props
    div className: 'form-step',
      div className: 'form-step-counter', @props.step
      div className: 'form-step-content',
        div className: 'form-step-title',
          @props.title,
          div className: 'form-step-error',
            error
        div className: 'clear-both'
        @props.children
      div className: 'clear-both'

@TransactionForm = React.createClass
  getInitialState: ->
    step: 1, giving: null, amount: null, peer: null, message: null
  setAction: (b) ->
    @setState giving: b
    @setState step: 2 unless @state.step > 1
  setAmount: (a) ->
    @setState amount: a
    @setState step: 3 unless @state.step > 2
  setPeer: (p) ->
    @setState peer: p
    @setState step: 4 unless @state.step > 3
  setMessage: (m) ->
    @setState message: m
    @setState step: 5 unless @state.step > 4
  submit: (e) ->
    e.preventDefault()

    { giving, peer } = @state
    { user, csrf_token } = @props

    errors = @errors()
    if Object.keys(errors).length != 0
      return

    if giving
      debtor   = user.name
      creditor = peer
    else
      debtor   = peer
      creditor = user.name

    $('<input />')
      .attr('name', 'transaction[debtor]')
      .attr('value', debtor)
      .attr('type', 'hidden')
      .appendTo(@refs.form)
    $('<input />')
      .attr('name', 'transaction[creditor]')
      .attr('value', creditor)
      .attr('type', 'hidden')
      .appendTo(@refs.form)
    $('<input />')
      .attr('name', 'authenticity_token')
      .attr('value', csrf_token)
      .attr('type', 'hidden')
      .appendTo(@refs.form)

    @refs.form.submit()
  errors: ->
    { amount, giving, message, peer } = @state
    { peers, user }                   = @props

    errors = {}

    errors['giving'] = 'Please select an action.' unless giving != null

    unless amount
      errors['amount'] = 'Please fill in an amount.'
    else if parseFloat(amount) <=  0
      errors['amount'] = 'Please fill in a positive number.'

    unless message && message != ""
      errors['message'] = 'Please fill in a message.'

    unless peer && peers.includes(peer) && peer != user
      errors['peer'] = 'Please select a valid Zeus member.'

    errors
  render: ->
    { step, amount, giving, message, peer } = @state
    { peers }                               = @props

    errors = @errors()

    div id: 'transaction-form',
      h3 null, 'Transfer some money'
      form ref: 'form', action: url('transactions'), acceptCharset: 'UTF-8', method: 'post',
        Step step: 1, title: 'What do you want to do?',
          Action giving: giving, setAction: @setAction
        if step >= 2
          Step {
            step: 2,
            title: "How much do you want to #{if giving then 'give' else 'receive'}?",
            error: errors['amount'] if step > 2
          },
            Amount setAmount: @setAmount
        if step >= 3
          Step {
            step: 3,
            title: "Who do you want to #{if giving then 'give it to' else 'receive it from'}?",
            error: errors['peer'] if step > 3
          },
            Peer peer: peer, peers: peers, setPeer: @setPeer
        if step >= 4
          Step {
            step: 4,
            title: "Why do you want to #{if giving then 'give' else 'receive'} this?",
            error: errors['message'] if step > 4
          },
            Message setMessage: @setMessage
        if step >= 5
          Submit onClick: @submit
      div className: 'clear-both'
