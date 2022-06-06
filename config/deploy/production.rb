server 'tab.zeus.gent',
	user: 'tab',
	roles: %w{web app db},
	ssh_options: {
		forward_agent: true,
		auth_methods: %w(publickey),
		port: 2222
	}
