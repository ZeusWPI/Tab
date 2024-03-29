import React from "react";

import Select from 'react-select';
import Fuse from 'fuse.js';

const url = function (path) {
  return (window.base_url || '') + "/" + path;
};

class ActionType {
  static Take =  new ActionType(
    "take",
    "Take money",
    "take",
    "take it from",
    "take",
    <svg xmlns="http://www.w3.org/2000/svg" className="h-5 w-5 mr-2 -ml-1" fill="none" viewBox="0 0 24 24"
  stroke="currentColor" strokeWidth="2">
    <path strokeLinecap="round" strokeLinejoin="round"
  d="M14.121 15.536c-1.171 1.952-3.07 1.952-4.242 0-1.172-1.953-1.172-5.119 0-7.072 1.171-1.952 3.07-1.952 4.242 0M8 10.5h4m-4 3h4m9-1.5a9 9 0 11-18 0 9 9 0 0118 0z"/>
    </svg>
)
  static Request =  new ActionType(
    "request",
    "Request money",
    "request",
    "request it from",
    "request",
    <svg xmlns="http://www.w3.org/2000/svg" className="h-5 w-5 mr-2 -ml-1" fill="none" viewBox="0 0 24 24"
         stroke="currentColor" strokeWidth="2">
      <path strokeLinecap="round" strokeLinejoin="round" d="M19 14l-7 7m0 0l-7-7m7 7V3"/>
    </svg>
  )
  static Give = new ActionType(
    "give",
    "Give money",
    "give",
    "give it to",
    "give",
    <svg xmlns="http://www.w3.org/2000/svg" className="h-5 w-5 ml-2 -mr-1" fill="none" viewBox="0 0 24 24"
         stroke="currentColor" strokeWidth="2">
      <path strokeLinecap="round" strokeLinejoin="round" d="M5 10l7-7m0 0l7 7m-7-7v18"/>
    </svg>
  )

  constructor(identifier, buttonText, howMuchDoYouWantToText, whoDoYouWantToText, whyDoYouWantToText, svg) {
    this.identifier = identifier;
    this.buttonText = buttonText;
    this.howMuchDoYouWantToText = howMuchDoYouWantToText;
    this.whoDoYouWantToText = whoDoYouWantToText;
    this.whyDoYouWantToText = whyDoYouWantToText;
    this.svg = svg;
  }

  isGiving = () => this === ActionType.Give
  isTaking = () => this === ActionType.Take
  isRequesting = () => this === ActionType.Request
}

class Action extends React.Component {
  buttonClass(action) {
    const { action: activeAction, penning } = this.props;
    const c = ['inline-flex items-center py-2 px-4 text-sm font-medium focus:outline-none border focus:z-10 focus:ring-4'];

    if((penning && (action === ActionType.Take)) || (!penning && (action === ActionType.Request))) {
      c.push('rounded-l-lg')
    } else if(action === ActionType.Give) {
      c.push('rounded-r-lg')
    }

    if (action === activeAction) {
      c.push('bg-blue-700 text-white hover:bg-blue-800')
    } else {
      c.push('text-gray-900 ng-white border-gray-200 hover:bg-gray-100 hover:text-blue-700 focus:ring-gray-200')
    }

    return c.join(' ');
  }

  onClick(action) {
    return this.props.setAction(action);
  }

  button(action) {
    return <button
      className={this.buttonClass(action)}
      onClick={() => this.onClick(action)}
      type={'button'}
    >
      { action !== ActionType.Give && action.svg }
      { action.buttonText }
      { action === ActionType.Give && action.svg }
    </button>
  }

  render() {
    const { penning } = this.props;

    return (
      <div className={'inline-flex rounded-md shadow-sm'}>
        { penning && this.button(ActionType.Take)}
        { this.button(ActionType.Request) }
        { this.button(ActionType.Give) }
      </div>
    );
  }
}

class Amount extends React.Component {
  onChange = (ref) => {
    return this.props.setAmount(ref.target.value);
  }

  format(ref) {
    const { target } = ref;
    if (target.value) {
      return target.value = parseFloat(target.value).toFixed(2);
    }
  }

  render() {
    return(
      <div className="relative z-0 w-full mb-6 group">
        <div className="flex">
          <span className="inline-flex items-center px-3 text-sm text-gray-900 bg-gray-100 border border-r-0 border-gray-300 rounded-l-md">
            Ƶ
          </span>
          <input
            name={'transaction[euros]'}
            onBlur={this.format}
            onChange={this.onChange}
            placeholder={'0.00'}
            type={'number'}
            step="0.01"
            className="block flex-initial p-2 w-1/2 sm:text-sm rounded-none rounded-r-lg bg-white border border-gray-200 text-gray-900 focus:ring-blue-500 focus:border-blue-500 border-gray-300"
          />
        </div>
      </div>
    );
  }
}

class Peer extends React.Component {
  constructor(props) {
    super(props);

    const { peers } = this.props;

    const peerOptions = this.toOptions(peers);

    const fuse = new Fuse(peerOptions, { keys: ["label"] });

    this.state = {
      options: peerOptions,
      fuse: fuse
    }
  }

  toOptions(peers) {
    return peers.map(p => ({value: p, label: p}));
  }

  setOptions(options) {
    this.setState({
      options: options
    });
  }

  onInputChange(inputValue) {
    const { fuse } = this.state;
    const { peers } = this.props;

    this.setOptions(!!inputValue ? fuse.search(inputValue).map(value => value.item) : this.toOptions(peers));
  }

  setPeer(appel) {
    return this.props.setPeer(appel.value);
  }

  render() {
    const { options } = this.state;
    const { peer } = this.props;
    const peerOption = options.find(o => o.value === peer)

    return (
      <div className={'relative z-0 w-full mb-6 group'}>
        <Select
          value={peerOption}
          onChange={(e) => this.setPeer(e)}
          options={options}
          onInputChange={inputValue => this.onInputChange(inputValue)}
          menuPortalTarget={document.body}
          menuPosition={'fixed'}
          className={'text-sm w-2/3 border-gray-200 text-gray-900 focus:ring-blue-500 focus:border-blue-500 z-20'}
        />
      </div>
    );
  }
}

class Message extends React.Component {
  onChange = (ref) => {
    return this.props.setMessage(ref.target.value);
  }

  render() {
    return (
      <div className="relative z-0 w-full mb-6 group">
        <input
          className="block flex-1 min-w-0 w-2/3 p-2.5 text-sm bg-white border rounded-lg border-gray-200 text-gray-900 focus:ring-blue-500 focus:border-blue-500"
          name="transaction[message]"
          onChange={this.onChange}
          placeholder="Message"
          type='text'
        />
      </div>
    );
  }
}

class Submit extends React.Component {
  onClick(b) {
    return this.props.onClick(b);
  }

  buttonClasses(enabled) {
    return enabled ?
      'bg-blue-700 hover:bg-blue-800' :
      'bg-blue-400 cursor-not-allowed';
  }

  render() {
    const { action, step, enabled } = this.props;

    return (
      <li className="mb-1 ml-6">
        <span className="flex absolute -left-3 justify-center items-center w-6 h-6 bg-blue-200 rounded-full ring-8 ring-white">
          { step }
        </span>
        <button
          className={`${this.buttonClasses(enabled)} inline-flex text-white -mt-6 focus:ring-4 focus:outline-none focus:ring-blue-300 font-medium rounded-lg text-sm w-full sm:w-auto px-5 py-2.5 text-center`}
          disabled={!enabled}
          onClick={() => this.onClick()}
          type="submit"
        >
          { action.buttonText }
        </button>
      </li>
    );
  }
}

class Step extends React.Component {
  render() {
    const { error, step, title, children } = this.props;

    return (
      <li className="mb-6 ml-6">
        <span className="flex absolute -left-3 justify-center items-center mt-0.5 w-6 h-6 bg-blue-200 rounded-full ring-8 ring-white">
          { step }
        </span>
        <h3 className="flex items-center mb-1 text-lg font-semibold text-gray-900">
          { title }
        </h3>
        <div className="block mb-2 text-sm font-normal leading-none text-red-400">
          { error }
        </div>
        <div className="mb-2 text-base font-normal text-gray-500">
          { children }
        </div>
      </li>
    );
  }
}

class TransactionForm extends React.Component {

  constructor(props) {
    super(props);

    this.state = {
      step: 1,
      action: null,
      amount: null,
      peer: null,
      message: null
    }

    this.form = React.createRef();
  }

  setAction(action) {
    this.setState({
      action: action
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
    const { amount, action, message, peer } = this.state;
    const { peers, user_name, balance, penning } = this.props;
    const errors = {};

    if (action === null) {
      errors['action'] = 'Please select an action.';
    }

    if (!amount) {
      errors['amount'] = 'Please fill in an amount.';
    } else if (parseFloat(amount) <= 0) {
      errors['amount'] = 'Please fill in a positive number.';
    } else if (!penning && action.isGiving() && amount && (parseFloat(amount) * 100 > balance)) {
      errors['amount'] = 'Insufficient funds.';
    }

    if (!(message && message !== "")) {
      errors['message'] = 'Please fill in a message.';
    }

    if (!peer) {
      errors['peer'] = 'Please select a Zeus member.';
    } else if (action.isGiving() && peer === user_name) {
      errors['peer'] = "No need to give yourself money, you've already got it.";
    } else if ((action.isTaking() || action.isRequesting()) && peer === user_name) {
      errors['peer'] = "No need to ask yourself money, you've already got it.";
    } else if (!peers.includes(peer)) {
      errors['peer'] = 'Please select a valid Zeus member.';
    }

    console.warn(errors);

    return errors;
  }

  handleSubmit = (e) => {
    e.preventDefault()

    const { action, peer } = this.state;
    const { user_name, csrf_token } = this.props;
    const errors = this.errors();

    let debtor, creditor;

    if (Object.keys(errors).length !== 0) {
      return;
    }

    if (action.isGiving()) {
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

    const action_input = document.createElement('input')
    action_input.setAttribute('type', 'hidden')
    action_input.setAttribute('name', 'transaction[action]')
    action_input.setAttribute('value', action.identifier)
    this.form.current.appendChild(action_input)

    const authenticity_token_input = document.createElement('input')
    authenticity_token_input.setAttribute('type', 'hidden')
    authenticity_token_input.setAttribute('name', 'authenticity_token')
    authenticity_token_input.setAttribute('value', csrf_token)
    this.form.current.appendChild(authenticity_token_input)

    return this.form.current.submit();
  }

  render() {
    const { step, action, peer } = this.state;
    const { peers, penning } = this.props;
    const errors = this.errors();

    return (
      <form
            ref={this.form}
            action={url('transactions')}
            acceptCharset={'UTF-8'}
            method={'post'}
            onSubmit={this.handleSubmit}
          >
        <ol className="relative border-l border-gray-200">
          <Step
            step={1}
            title={"What do you want to do?"}
          >
            <Action
              action={action}
              penning={penning}
              setAction={(action) => this.setAction(action)} />
          </Step>
          { step >= 2 ?
            <Step
              step={2}
              title={"How much do you want to " + action.howMuchDoYouWantToText + "?"}
              error={step > 2 ? errors['amount'] : void 0}
            >
              <Amount setAmount={(amount) => this.setAmount(amount) } />
            </Step>
            : void 0 }
          { step >= 3 ?
            <Step
              step={3}
              title={"Who do you want to " + action.whoDoYouWantToText + "?"}
              error={step > 3 ? errors['peer'] : void 0}
            >
              <Peer peer={peer} peers={peers} setPeer={(peer) => this.setPeer(peer)} />
            </Step>
            : void 0 }
          { step >= 4 ?
            <Step
              step={4}
              title={"Why do you want to " + action.whyDoYouWantToText + " this?"}
              error={step > 4 ? errors['message'] : void 0}
            >
              <Message setMessage={(message) => this.setMessage(message)} />
            </Step>
            : void 0 }
          { step >= 5 ?
            <Submit
              action={action}
              step={5}
              onClick={this.handleSubmit}
              type={"submit"}
              enabled={Object.keys(errors).length === 0}
            />
            : void 0}
        </ol>
      </form>
    );
  }
}

export default TransactionForm
