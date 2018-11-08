def version = ''
def buildName = ''
withCredentials([usernamePassword(credentialsId: 'ID', passwordVariable: 'password', usernameVariable: 'username')]) {
node('master') {
	stage('Clone') { 
		dir('task6'){
			git branch: 'task6', url: 'https://github.com/mikhailyesman/EPAM_Test.git'
		}
	}
	stage('Build and incVersion') { 
		dir('task6'){
			sh '/opt/gradle/gradle-4.10.2/bin/gradle incrementVersion'
			sh '/opt/gradle/gradle-4.10.2/bin/gradle build'
		}
	}
	stage('read version of buid'){
		dir('task6/build/libs'){
			String snapshot="libs"
			new File(pwd()).eachFileRecurse{file->
			buildName=file.name.replace(".war","")
		}
	}
		dir('task6'){
			Properties properties = new Properties()
			sh 'ls'
			File propertiesFile = new File(pwd()+'/gradle.properties')
			def props = readProperties  file: pwd()+'/gradle.properties'
			version = props.version+'.'+props.buildVersion
		}
	}
		stage('Upload to nexus') {
			dir('task6'){
				sh "curl -v -u ${nexus_username}:${nexus_password} --upload-file build/libs/${buildName}.war http://localhost:8081/nexus/content/repositories/snapshots/${buildName}/${version}/${buildName}.war"
			}
		}
	}
	for (i=1; i<=2; i++){
	node (nodeName+i){
		stage ('dowload warfile tomcat'+i){
			httpRequest responseHandle: 'NONE', url: 'http://192.168.10.44/jkmanager?cmd=update&from=list&w=lb&sw=tomcat1&vwa=1'
			sh "cp ${buildName}.war /usr/share/tomcat/webapps/"
			sleep 10
			httpRequest responseHandle: 'NONE', url: 'http://192.168.10.44/jkmanager?cmd=update&from=list&w=lb&sw=tomcat1&vwa=0'
		}
	}
	node('master') {
		stage('Git commit & push') {
			 dir('task6') {
				sh 'git add *'
				sh 'git config --global user.email "mikhailyesman@gmail.com"'
				sh 'git config --global user.name "mikhailyesman"'
				sh "git commit -m 'new version ${version}'"
				sh "git push https://${username}:${password}@github.com/mikhailyesman/EPAM_Test.git --all"
				sh 'git checkout master'
				sh 'git merge task6'
				sh "git tag -a v${version} -m 'version ${version}'"
				sh 'git push https://${username}:${password}@github.com/mikhailyesman/EPAM_Test.git --tags'
				sh 'git push https://${username}:${password}@github.com/mikhailyesman/EPAM_Test.git --all'
			} 
		}
	}
}