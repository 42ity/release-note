@Library('etn-ipm2-jenkins') _

pipeline {
    // This job only does a spell-check so far, needs "aspell" in PATH
    // but does no pushing, coverage or other time-consuming tasks

    agent {
        docker {
            label 'docker-dev-1'
            image infra.getDockerAgentImage()
            args '--oom-score-adj=100 --security-opt seccomp=unconfined'
        }
    }

    triggers {
        pollSCM 'H/5 * * * *'
    }

    options {
        disableConcurrentBuilds()
        skipDefaultCheckout()
    }

    stages {
        stage ('git') {
            steps {
                retry(3) {
                    checkout([
                        $class: 'GitSCM',
                        branches: scm.branches,
                        extensions: scm.extensions + [
                            [$class: 'CloneOption', noTags: true],
                            [$class: 'SubmoduleOption', recursiveSubmodules: true, parentCredentials: true]
                        ],
                        userRemoteConfigs: scm.userRemoteConfigs
                    ])
                }
            }
        }

        stage ('check-json-generation') {
            steps {
                sh """ make clean check-json """
                archiveArtifacts(artifacts: 'latest.json', allowEmptyArchive: false)
            }
        }

        stage ('check-spelling') {
            steps {
                script {
                    def ret = sh (returnStatus:true, script:"""
                        if ( command -v aspell) ; then
                            make clean spellcheck
                        else
                            echo "SKIPPED SPELLCHECK (no tools found)"
                            exit 42
                        fi
                        """)
                    if (ret == 42) {
                        unstable "SKIPPED SPELLCHECK"
                    }
                }
            }
        }
    }
}
