# $1 -> RAM (1G)
# $2 -> Version (1.16)

echo "eula="$eula > /app/eula.txt
echo ram $1
echo version $2
rm -r paperclip.jar
wget https://papermc.io/ci/job/Paper-$2/lastSuccessfulBuild/artifact/paperclip.jar
cp paperclip.jar /app/paper.jar

started=0
[ -f /shared/cmd ] || touch /shared/cmd
cmd=$(cat /shared/cmd)
cmdold=$cmd
while [ 1 ]
do
	mc=$(cat /shared/mcserver)
	cmd=$(cat /shared/cmd)
	if [[ "$mc" == "s" ]] && [ $started == 0 ]
	then	
		# Install world file if provided
		cd /shared
		unzip world.zip -d /world && (
			rm world.zip
			cd /world
			[ $(ls -l | wc -l) -gt 2 ] || cd "$(ls)"
			mkdir /app/world_the_end
			mkdir /app/world
			mkdir /app/world_nether
			mv ./DIM1 /app/world_the_end/
			mv ./DIM-1 /app/world_nether/
			mv * /app/world/
			rm -rf /world
		)

		# Start minecraft
		cd /
		tmux new -s minecraft -d 'cd /app && java -Xms'$1' -Xmx'$1' -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1 -Dusing.aikars.flags=https://mcflags.emc.gs -Daikars.new.flags=true -jar paper.jar'
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
		# maybe some data gets destroyed (?) (stuff that's not in DIM-1)
		mv world_nether/DIM-1 world/
		mv world_the_end/DIM1 world/
		zip -r ../www/$name world/* 
		echo https://mc.bundr.net/$name > /shared/lastfileurl
		rm -r world world_nether world_the_end logs
		cd ..
		echo stopped minecraft server
		tmux kill-session -t minecraft
	fi

	now=$(date +%s)
	for f in /www/world*.zip
        do
		filedate=$(date -r $f +%s)
		[ $(expr $now - 86400) -ge $filedate ] && rm -rf "$f"
	done

	if [[ $cmd != $cmdold ]]
	then
		tmux send-keys -t minecraft "$cmd" ENTER
		cmdold=$cmd
	fi
	sleep 5
done


