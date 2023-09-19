#!/usr/bin/expect

set timeout 10
set host "s0.serv00.com"
set username "auhaij"
set password "pwd"

spawn ssh $username@$host

expect {
    "yes/no" {
        send "yes\r"
        exp_continue
    }

    "Password" {
        send "$password\r"
    }
}

expect {
    "$username@" {
        puts "Logged in to $host as $username"
		sleep 3
        # 执行其他命令
        send "tar -cvzf \"/home/auhaij/typecho-\$(date +%F).tar.gz\" /home/auhaij/domains/auhaij.serv00.net/\r"
        expect "$username@"
		sleep 3
        send "curl -u \"admin:pwd\" -T /home/auhaij/typecho-\$(date +%F).tar.gz -s -w \"%{http_code}\" \"https://alist.alist.xyz/alist/dav/E5-auhaij@3523c2/typecho/\"\r"
        expect "$username@"
		sleep 3
        send "rm /home/auhaij/typecho-\$(date +%F).tar.gz\r"
        expect "$username@"
        sleep 3

        # 退出
        send "exit\r"
    }
    "Permission denied" {
        puts "Login failed. Check your credentials."
        exit 1
    }
}

expect eof
