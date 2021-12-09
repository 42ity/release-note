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
        skipDefaultCheckout()
    }

    stages {

        stage ('git') {
            steps {
                retry(3) {
                    checkout scm
                    sh """ git submodule init && git submodule update || true """

/*
                    // Ideally, we need to ensure submodules are here...
                    // or fallback using agent-provided JSON.sh if any on PATH
                    // But CI farm (or its connectivity) does not cooperate
                    checkout([
                        $class: 'GitSCM',
                        branches: [[name: "${env.GIT_COMMIT}"]],
                        doGenerateSubmoduleConfigurations: false,
                        extensions: [[
                            $class: 'SubmoduleOption',
                            disableSubmodules: false,
                            parentCredentials: true,
                            recursiveSubmodules: true,
                            reference: '',
                            trackingSubmodules: false
                        ]],
                        submoduleCfg: [],
                        userRemoteConfigs: scm.userRemoteConfigs
                        ])
*/
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
