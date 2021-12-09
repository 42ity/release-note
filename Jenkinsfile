@Library('etn-ipm2-jenkins') _

pipeline {
    // This job only does a spell-check so far, needs "aspell" in PATH
    // but does no pushing, coverage or other time-consuming tasks
    agent {
        label infra.getAgentLabels()
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
                sh """ make check-json """
            }
        }

        stage ('check-spelling') {
            steps {
                sh """ make spellcheck """
            }
        }
    }
}
