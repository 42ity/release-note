@Library('etn-ipm2-jenkins') _

pipeline {
    // This job only does a spell-check so far, needs "aspell" in PATH
    // but does no pushing, coverage or other time-consuming tasks
/*
    agent {
        label infra.getAgentLabels()
    }
*/

    agent {
        docker {
            label 'docker-dev-1'
            image infra.getDockerAgentImage()
            args '--oom-score-adj=100 -v /etc/ssh/id_rsa_git-proxy-cache:/etc/ssh/id_rsa_git-proxy-cache:ro -v /etc/ssh/ssh_config:/etc/ssh/ssh_config:ro -v /etc/gitconfig:/etc/gitconfig:ro'
        }
    }

    triggers {
        pollSCM 'H/5 * * * *'
    }

    options {
        disableConcurrentBuilds()
    }

    stages {
        stage ('check-json-generation') {
            steps {
                sh """ make clean check-json """
                archiveArtifacts(artifacts: 'latest.json', allowEmptyArchive: false)
            }
        }

        stage ('check-spelling') {
            steps {
                sh """
if ( command -v aspell) ; then
    make clean spellcheck
else
    echo "SKIPPED SPELLCHECK (no tools found)"
fi
"""
            }
        }
    }
}