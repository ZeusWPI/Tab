(function () {
    let Action, Amount, Message, Peer, Step, Submit, button, div, form, h3, input, option, select, url, _ref;

    _ref = React.DOM, button = _ref.button, div = _ref.div, form = _ref.form, h3 = _ref.h3, input = _ref.input, option = _ref.option, select = _ref.select;

    url = function (path) {
        return (window.base_url || '') + "/" + path;
    };

    Action = React.createFactory(React.createClass({
        buttonClass: function (b) {
            let c, giving;
            giving = this.props.giving;
            c = ['btn', 'btn-default'];
            if (b === giving) {
                c.push('active');
            }
            return c.join(' ');
        },
        onClick: function (b) {
            return (function (_this) {
                return function () {
                    return _this.props.setAction(b);
                };
            })(this);
        },
        render: function () {
            let giving;
            giving = this.props.giving;
            return div({
                className: 'btn-group btn-group-lg'
            }, button({
                type: 'button',
                className: this.buttonClass(true),
                onClick: this.onClick(true)
            }, 'Give Money'), button({
                type: 'button',
                className: this.buttonClass(false),
                onClick: this.onClick(false)
            }, 'Request Money'));
        }
    }));

    Amount = React.createFactory(React.createClass({
        onChange: function (ref) {
            return this.props.setAmount(ref.target.value);
        },
        format: function (ref) {
            let t;
            t = ref.target;
            if (t.value) {
                return t.value = parseFloat(t.value).toFixed(2);
            }
        },
        render: function () {
            return div({
                className: 'row'
            }, div({
                className: 'col-xs-8'
            }, div({
                className: 'input-group'
            }, div({
                className: 'input-group-addon'
            }, '€'), input({
                className: 'form-control input-lg',
                name: 'transaction[euros]',
                onBlur: this.format,
                onChange: this.onChange,
                placeholder: '0.00',
                type: 'number'
            }))));
        }
    }));

    Peer = React.createFactory(React.createClass({
        onChange: function (ref) {
            return this.props.setPeer(ref.target.value);
        },
        options: function () {
            var peer, peers, re, _ref1;
            _ref1 = this.props, peer = _ref1.peer, peers = _ref1.peers;
            if (peer === '' || peers.includes(peer)) {
                return [];
            } else {
                re = new RegExp(peer, 'i');
                return peers.filter(function (s) {
                    return s.match(re) !== null;
                });
            }
        },
        inputClass: function (n) {
            let c;
            c = ['form-control', 'input-lg'];
            if (n > 0) {
                c.push('active');
            }
            return c.join(' ');
        },
        setPeer: function (p) {
            return (function (_this) {
                return function () {
                    return _this.props.setPeer(p);
                };
            })(this);
        },
        render: function () {
            let options;
            options = this.options();
            return div({
                className: 'row'
            }, div({
                className: 'col-xs-8'
            }, div({
                className: 'suggestions-wrapper'
            }, input({
                className: this.inputClass(options.length),
                onChange: this.onChange,
                placeholder: 'Zeus member',
                type: 'text',
                value: this.props.peer || ''
            }), options.length !== 0 ? div({
                className: 'suggestions'
            }, this.options().map((function (_this) {
                return function (s, i) {
                    return div({
                        className: 'suggestion',
                        key: i,
                        onClick: _this.setPeer(s)
                    }, s);
                };
            })(this))) : void 0)));
        }
    }));

    Message = React.createFactory(React.createClass({
        onChange: function (ref) {
            return this.props.setMessage(ref.target.value);
        },
        render: function () {
            return div({
                className: 'row'
            }, div({
                className: 'col-xs-8'
            }, input({
                className: 'form-control input-lg',
                name: 'transaction[message]',
                onChange: this.onChange,
                placeholder: 'Message',
                type: 'text'
            })));
        }
    }));

    Submit = React.createFactory(React.createClass({
        render: function () {
            let onClick;
            onClick = this.props.onClick;
            return div({
                className: 'row'
            }, div({
                className: 'col-xs-4 col-xs-offset-4'
            }, button({
                className: 'btn btn-default btn-lg btn-block',
                onClick: onClick,
                type: 'submit'
            }, 'Confirm')));
        }
    }));

    Step = React.createFactory(React.createClass({
        render: function () {
            let error;
            error = this.props.error;
            return div({
                className: 'form-step'
            }, div({
                className: 'form-step-counter'
            }, this.props.step), div({
                className: 'form-step-content'
            }, div({
                className: 'form-step-title'
            }, this.props.title, div({
                className: 'form-step-error'
            }, error)), div({
                className: 'clear-both'
            }), this.props.children), div({
                className: 'clear-both'
            }));
        }
    }));

    this.TransactionForm = React.createClass({
        getInitialState: function () {
            return {
                step: 1,
                giving: null,
                amount: null,
                peer: null,
                message: null
            };
        },
        setAction: function (b) {
            this.setState({
                giving: b
            });
            if (!(this.state.step > 1)) {
                return this.setState({
                    step: 2
                });
            }
        },
        setAmount: function (a) {
            this.setState({
                amount: a
            });
            if (!(this.state.step > 2)) {
                return this.setState({
                    step: 3
                });
            }
        },
        setPeer: function (p) {
            this.setState({
                peer: p
            });
            if (!(this.state.step > 3)) {
                return this.setState({
                    step: 4
                });
            }
        },
        setMessage: function (m) {
            this.setState({
                message: m
            });
            if (!(this.state.step > 4)) {
                return this.setState({
                    step: 5
                });
            }
        },
        submit: function (e) {
            let creditor, csrf_token, debtor, errors, giving, peer, user, _ref1, _ref2;
            e.preventDefault();
            _ref1 = this.state, giving = _ref1.giving, peer = _ref1.peer;
            _ref2 = this.props, user = _ref2.user, csrf_token = _ref2.csrf_token;
            errors = this.errors();
            if (Object.keys(errors).length !== 0) {
                return;
            }
            if (giving) {
                debtor = user.name;
                creditor = peer;
            } else {
                debtor = peer;
                creditor = user.name;
            }
            $('<input />').attr('name', 'transaction[debtor]').attr('value', debtor).attr('type', 'hidden').appendTo(this.refs.form);
            $('<input />').attr('name', 'transaction[creditor]').attr('value', creditor).attr('type', 'hidden').appendTo(this.refs.form);
            $('<input />').attr('name', 'authenticity_token').attr('value', csrf_token).attr('type', 'hidden').appendTo(this.refs.form);
            return this.refs.form.submit();
        },
        errors: function () {
            let amount, errors, giving, message, peer, peers, user, _ref1, _ref2;
            _ref1 = this.state, amount = _ref1.amount, giving = _ref1.giving, message = _ref1.message, peer = _ref1.peer;
            _ref2 = this.props, peers = _ref2.peers, user = _ref2.user;
            errors = {};
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
            if (!(peer && peers.includes(peer) && peer !== user)) {
                errors['peer'] = 'Please select a valid Zeus member.';
            }
            return errors;
        },
        render: function () {
            var amount, errors, giving, message, peer, peers, step, _ref1;
            _ref1 = this.state, step = _ref1.step, amount = _ref1.amount, giving = _ref1.giving, message = _ref1.message, peer = _ref1.peer;
            peers = this.props.peers;
            errors = this.errors();
            return div({
                id: 'transaction-form'
            }, h3(null, 'Transfer some money'), form({
                ref: 'form',
                action: url('transactions'),
                acceptCharset: 'UTF-8',
                method: 'post'
            }, Step({
                step: 1,
                title: 'What do you want to do?'
            }, Action({
                giving: giving,
                setAction: this.setAction
            })), step >= 2 ? Step({
                step: 2,
                title: "How much do you want to " + (giving ? 'give' : 'receive') + "?",
                error: step > 2 ? errors['amount'] : void 0
            }, Amount({
                setAmount: this.setAmount
            })) : void 0, step >= 3 ? Step({
                step: 3,
                title: "Who do you want to " + (giving ? 'give it to' : 'receive it from') + "?",
                error: step > 3 ? errors['peer'] : void 0
            }, Peer({
                peer: peer,
                peers: peers,
                setPeer: this.setPeer
            })) : void 0, step >= 4 ? Step({
                step: 4,
                title: "Why do you want to " + (giving ? 'give' : 'receive') + " this?",
                error: step > 4 ? errors['message'] : void 0
            }, Message({
                setMessage: this.setMessage
            })) : void 0, step >= 5 ? Submit({
                onClick: this.submit
            }) : void 0), div({
                className: 'clear-both'
            }));
        }
    });

}).call(this);