node ('master'){
	stage('clone'){
		git branch: 'task7', credentialsId: '1bbb7220-7a2e-4a0f-A40F-85d7d49cdd89', url: 'https://github.com/mikhailyesman/EPAM_Test.git'
	}
	stage('build'){
		sh 'chmod +x gradlew'
		sh './gradlew build'
		sh './gradlew task incrementVersion'
	}

	def DataGPFile = readFile 'gradle.properties'
	String v2=DataGPFile.substring(DataGPFile.lastIndexOf('=')+1)
	String v1=DataGPFile.substring(DataGPFile.lastIndexOf('.')-1,DataGPFile.lastIndexOf('.')+2)
	String v= v1+'.'+v2.trim()
	println v1
	println v2
	
	
	
	stage('nexus'){
		NameFile = v
		println NameFile
		dir ('build/libs'){
			sh 'chmod +x task7.war'
			withCredentials([usernameColonPassword(credentialsId: '652c7f0f-598d-4673-982f-10fb6b613c1a', variable: 'nexus')]) {
				sh "curl -XPUT -u $nexus -T task7.war 'http://100.64.0.111:8081/repository/snapshot/task7/${NameFile}/task7.war'"
			}
		}
	}
	stage('docker'){
	    println NameFile
	    println 'sssssssssssss'
	    
	    
		sh "docker build --build-arg vers=${NameFile} -t greeting:${NameFile} ."
		println 'sssssssssssss'
		sh "docker tag greeting:${NameFile} 100.64.0.111:5000/greeting:${NameFile}"
		sh "docker push 100.64.0.111:5000/greeting:${NameFile}"
		
	}
	stage('service'){
		def ver2 = sh returnStatus: true, script: 'curl -X POST http://100.64.0.111:8091/task7/'
		script {
			if (ver2) {
				sh "docker service create --name greeting -p 8091:8080 --replicas=2 100.64.0.111:5000/greeting:${NameFile} "
			}
			else {
					sh "docker service update --force greeting --image 100.64.0.111:5000/greeting:${NameFile} "
			}
		}
	}	
	stage('verify'){
	    
	    sh "curl -X POST http://100.64.0.111:8091/task7/"
	    sleep 10
		def ver1 = sh(returnStdout: true, script: "curl -X POST http://100.64.0.111:8091/task7/").trim()
		println NameFile
		println 'ggggggggg'
		
		
		script {
			if (ver1.contains(NameFile)) {
				echo '+'
			}
			else {
				error '-'
			}
		}
	}
	stage('commit'){
		withCredentials([usernamePassword(credentialsId: '1bbb7220-7a2e-4a0f-a40f-85d7d49cdd89', passwordVariable: 'GitPass', usernameVariable: 'GitLogin')]) {
			sh 'git config --global user.email "mikhailyesman@gmail.com"'
			sh "git commit -a -m 'New file version ${NameFile}'"
			sh "git remote set-url origin  https://${GitLogin}:${GitPass}@github.com/mikhailyesman/EPAM_Test.git"
			sh "git push --set-upstream origin task7"
			sh 'git checkout master'
			sh 'git merge task7'
			sh "git push -f origin master"
			sh "git tag '${NameFile}'"
		    sh "git push --tags" 
        }
    }
}
