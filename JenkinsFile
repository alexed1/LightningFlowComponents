pipeline{
    agent any
    stages {
        stage ('Checkout') {
            steps{
                checkout scm
            }
        }
        
        stage('Run PMD') {
            steps{
                sh './pmd-bin-6.36.0/bin/run.sh pmd -d . -R ./rulesets/pmd.xml -r ./pmd.xml -f xml -no-cache || exit 0'
            }
        }
        
        stage ('Build and Static Analysis') {
            steps{
                recordIssues tools: [
                    pmdParser(pattern: 'pmd.xml')],
                    qualityGates: [[threshold: 1, type: 'TOTAL', unstable: true]]
            }
        }
    }
}
