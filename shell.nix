let
	pkgs = import <nixpkgs> { };
in
pkgs.mkShell {
	buildInputs = with pkgs; [
		sqlite
		libmysqlclient
		nodejs-14_x
		ruby_2_7
		zlib
		(
			pkgs.writeShellScriptBin "start-docker" ''
				trap "systemd-run --user --no-block docker stop tab-db" 0
				docker run --name tab-db -p 3306:3306 --rm -v tab-db-data:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=tab -e MYSQL_DATABASE=tab -e MYSQL_USER=tab -e MYSQL_PASSWORD=tab mariadb:latest --general-log --general-log-file=/dev/stdout
			''
		)
	];
	shellHook = ''
		export TEST_DATABASE_URL="mysql2://tab:tab@127.0.0.1:3306/tab_test"
		export DATABASE_URL="mysql2://tab:tab@127.0.0.1:3306/tab"
		export GEM_HOME="$PWD/vendor/bundle/$(ruby -e 'puts RUBY_VERSION')"
		export PATH="$GEM_HOME/bin:$PATH"
	'';
}
