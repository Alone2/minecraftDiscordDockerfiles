# $1 -> RAM (1G)
# $2 -> Version (1.16)

echo "eula="$eula > /app/eula.txt
echo ram $1
echo version $2

started=0
[ -f /shared/cmd ] || touch /shared/cmd
cmd=$(cat /shared/cmd)
cmdold=$cmd
while [ 1 ]
do
	mc=$(curl /shared/mcserver)
	cmd=$(curl /shared/cmd)
	if [[ "$mc" == "s" ]] && [ $started == 0 ]
	then
		rm -r paperclip.jar
		wget https://papermc.io/ci/job/Paper-$2/lastSuccessfulBuild/artifact/paperclip.jar
		cp paperclip.jar /app/paper.jar
		tmux new -s minecraft -d 'cd /app && java -Xms'$1' -Xmx'$1' -jar paper.jar'
		echo started minecraft server
		started=1
	fi
	if [[ "$mc" == "r" ]] && [ $started == 1 ]
	then
		tmux send-keys -t minecraft "stop" ENTER
		started=0
		sleep 40
		cd app
		name=world$(date +%s).zip
		zip -r ../www/$name world world_nether world_end
		echo https://mc.bundr.net/$name > /shared/lastfileurl
		rm -r world world_nether world_end logs
		cd ..
		echo stopped minecraft server
		tmux kill-session -t minecraft
	fi
	if [[ $cmd != $cmdold ]]
	then
		tmux send-keys -t minecraft "$cmd" ENTER
		$cmdold=$cmd
	fi
	sleep 30
done


