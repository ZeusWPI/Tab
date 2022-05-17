import React from "react";

const url = function (path) {
  return (window.base_url || '') + "/" + path;
};

class Action extends React.Component {
  buttonClass(b) {
    const { giving } = this.props;
    const c = ['btn', 'btn-default'];

    if (b === giving) {
      c.push('active');
    }

    return c.join(' ');
  }

  onClick(b) {
    return this.props.setAction(b);
  }

  render() {
    return (
      <div className={'btn-group btn-group-lg'}>
        <button
          className={this.buttonClass(true)}
          onClick={() => this.onClick(true)}
          type={'button'}
        >
          Give Money
        </button>
        <button
          className={this.buttonClass(false)}
          onClick={() => this.onClick(false)}
          type={'button'}
        >
          Request money
        </button>
      </div>
    );
  }
}

class Amount extends React.Component {
  onChange = (ref) => {
    return this.props.setAmount(ref.target.value);
  }

  format(ref) {
    let t;
    t = ref.target;
    if (t.value) {
      return t.value = parseFloat(t.value).toFixed(2);
    }
  }

  render() {
    return <div className={'row'}>
      <div className={'col-xs-8'}>
        <div className={'input-group'}>
          <div className={'input-group-addon'}>
            €
          </div>
          <input
            className={'form-control input-lg'}
            name={'transaction[euros]'}
            onBlur={this.format}
            onChange={this.onChange}
            placeholder={'0.00'}
            type={'number'}
          />
        </div>
      </div>
    </div>;
  }
}

class Peer extends React.Component {
  onChange = (ref) => {
    return this.props.setPeer(ref.target.value);
  }

  options() {
    const { peer, peers } = this.props;
    let re;

    if (peer === '' || peers.includes(peer)) {
      return [];
    } else {
      re = new RegExp(peer, 'i');
      return peers.filter(function (s) {
        return s.match(re) !== null;
      });
    }
  }

  inputClass(n) {
    let c;
    c = ['form-control', 'input-lg'];
    if (n > 0) {
      c.push('active');
    }
    return c.join(' ');
  }

  setPeer(p) {
    return this.props.setPeer(p);
  }

  render() {
    let options;
    options = this.options();

    return (
      <div className={'row'}>
        <div className={'col-xs-8'}>
          <div className={'suggestions-wrapper'}>
            <input
              className={this.inputClass(options.length)}
              onChange={this.onChange}
              placeholder={'Zeus member'}
              type={'text'}
              value={this.props.peer || ''}
            />
            { options.length !== 0 ?
              this.options().map((s, i) => {
                return <div
                  className={'suggestion'}
                  key={i}
                  onClick={() => this.setPeer(s)}
                >
                  {s}
                </div>
              }) : void 0 }
          </div>
        </div>
      </div>
    );
  }
}

class Message extends React.Component {
  onChange = (ref) => {
    return this.props.setMessage(ref.target.value);
  }

  render() {
    return <div className="row">
      <div className="col-xs-8">
        <input
          className="form-control input-lg"
          name="transaction[message]"
          onChange={this.onChange}
          placeholder="Message"
          type='text'
        />
      </div>
    </div>;
  }
}

class Submit extends React.Component {
  onClick(b) {
    return this.props.onClick(b);
  }

  render() {

    return (
      <div className="row">
        <div className="col-xs-4 col-xs-offset-4">
          <button
            className="btn btn-default btn-lg btn-block"
            onClick={() => this.onClick()}
            type="submit"
          >
            Confirm
          </button>
        </div>
      </div>
    );
  }
}

class Step extends React.Component {
  render() {
    const { error, step, title, children } = this.props;

    return (
      <div className={'form-step'}>
        <div className={'form-step-counter'}>
          { step }
        </div>
        <div className={'form-step-content'}>
          <div className={'form-step-title'}>
            { title }
            <div className={'form-step-error'}>
              { error }
            </div>
            <div className={'clear-both'}></div>
            { children }
            <div className={'clear-both'}></div>
          </div>
        </div>
      </div>
    );
  }
}

class TransactionForm extends React.Component {

  constructor(props) {
    super(props);

    this.state = {
      step: 1,
      giving: null,
      amount: null,
      peer: null,
      message: null
    }

    this.form = React.createRef();
  }

  setAction(b) {
    this.setState({
      giving: b
    });

    if (!(this.state.step > 1)) {
      return this.setState({
        step: 2
      });
    }
  }

  setAmount(a) {
    this.setState({
      amount: a
    });

    if (!(this.state.step > 2)) {
      return this.setState({
        step: 3
      });
    }
  }

  setPeer(p) {
    this.setState({
      peer: p
    });

    if (!(this.state.step > 3)) {
      return this.setState({
        step: 4
      });
    }
  }

  setMessage(m) {
    this.setState({
      message: m
    });

    if (!(this.state.step > 4)) {
      return this.setState({
        step: 5
      });
    }
  }

  errors() {
    const { amount, giving, message, peer } = this.state;
    const { peers, user_name } = this.props;
    const errors = {};

    if (giving === null) {
      errors['giving'] = 'Please select an action.';
    }
    if (!amount) {
      errors['amount'] = 'Please fill in an amount.';
    } else if (parseFloat(amount) <= 0) {
      errors['amount'] = 'Please fill in a positive number.';
    }
    if (!(message && message !== "")) {
      errors['message'] = 'Please fill in a message.';
    }
    if (!(peer && peers.includes(peer) && peer !== user_name)) {
      errors['peer'] = 'Please select a valid Zeus member.';
    }
    console.log(errors);

    return errors;
  }

  handleSubmit(e) {
    const { giving, peer } = this.state;
    const { user_name, csrf_token } = this.props;
    const errors = this.errors();

    let debtor, creditor;

    if (Object.keys(errors).length !== 0) {
      return;
    }
    if (giving) {
      debtor = user_name;
      creditor = peer;
    } else {
      debtor = peer;
      creditor = user_name;
    }

    const debtor_input = document.createElement('input')
    debtor_input.setAttribute('type', 'hidden')
    debtor_input.setAttribute('name', 'transaction[debtor]')
    debtor_input.setAttribute('value', debtor)
    this.form.current.appendChild(debtor_input)

    const creditor_input = document.createElement('input')
    creditor_input.setAttribute('type', 'hidden')
    creditor_input.setAttribute('name', 'transaction[creditor]')
    creditor_input.setAttribute('value', creditor)
    this.form.current.appendChild(creditor_input)

    const authenticity_token_input = document.createElement('input')
    authenticity_token_input.setAttribute('type', 'hidden')
    authenticity_token_input.setAttribute('name', 'authenticity_token')
    authenticity_token_input.setAttribute('value', csrf_token)
    this.form.current.appendChild(authenticity_token_input)

    return this.form.current.submit();
  }

  render() {
    const { step, giving, peer } = this.state;
    const { peers } = this.props;
    const errors = this.errors();

    return (
      <div id={'transaction-form'}>
        <h3>Transfer some money</h3>
        <form
          ref={this.form}
          action={url('transactions')}
          acceptCharset={'UTF-8'}
          method={'post'}
          onSubmit={this.handleSubmit}
        >
          <Step
            step={1}
            title={"What do you want to do?"}
          >
            <Action
              giving={giving}
              setAction={(b) => this.setAction(b)} />
          </Step>
          { step >= 2 ?
            <Step
              step={2}
              title={"How much do you want to " + (giving ? 'give' : 'receive') + "?"}
              error={step > 2 ? errors['amount'] : void 0}
            >
              <Amount setAmount={(amount) => this.setAmount(amount) } />
            </Step>
            : void 0 }
          { step >= 3 ?
            <Step
              step={3}
              title={"Who do you want to " + (giving ? 'give it to' : 'receive it from') + "?"}
              error={step > 3 ? errors['peer'] : void 0}
            >
              <Peer peer={peer} peers={peers} setPeer={(peer) => this.setPeer(peer)} />
            </Step>
            : void 0 }
          { step >= 4 ?
            <Step
              step={4}
              title={"Why do you want to " + (giving ? 'give' : 'receive') + " this?"}
              error={step > 4 ? errors['message'] : void 0}
            >
              <Message setMessage={(message) => this.setMessage(message)} />
            </Step>
            : void 0 }
          { step >= 5 ?
            <Submit onClick={(e) => this.handleSubmit(e)} type={"submit"} />
            : void 0}
        </form>
        <div className={'clear-both'} />
      </div>
    );
  }
}

export default TransactionForm
