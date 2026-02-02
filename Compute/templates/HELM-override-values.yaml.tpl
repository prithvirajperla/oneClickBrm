# Copyright (c) 2023, 2025, Oracle and/or its affiliates.

# sample override file with bare minimum keys to be updated.
# This is a YAML-formatted file.

# For non-empty repository, "/" MUST be appended
imageRepository: "fra.ocir.io/fry4fxlvxkjt/communications_monetization/"
imagePullSecrets:
    - name: "brm-registry"
uniPass: "Q1RTdHJhaW5lcl8xMjMj"

db:
    sslMode: "NO"
    host: ${DBHOST}
    port: 1521
    user: sys
    password: ${DBPASS}
    serviceName: ${DBSERVICE}
    role: sysdba
    walletPassword: REJhZG1pbl8xMjMj
    walletType: sso
ocbrm:
    ece_deployed: false
    pdc_deployed: true
    LOG_LEVEL: 1
    isSSLEnabled: true
    isHPAEnabled: false
    root_key_rotate: false
    brm_root_pass: REJhZG1pbl8xMjMj
    rotate_password: false
    new_brm_root_password: ""
    rotate_brm_role_passwords: false
    # Set the passwords for brm users/roles
    brm_role_pass:
        acct_recv.0.0.0.1: ""
        bc_client.0.0.0.1: ""
        bill_inv_pymt_sub.0.0.0.1: ""
        billing.0.0.0.1: ""
        boc_client.0.0.0.1: ""
        collections.0.0.0.1: ""
        crypt_utils.0.0.0.1: ""
        cust_center.0.0.0.1: ""
        cust_mgnt.0.0.0.1: ""
        invoicing.0.0.0.1: ""
        java_client.0.0.0.1: ""
        load_utils.0.0.0.1: ""
        payments.0.0.0.1: ""
        pcc_client.0.0.0.1: ""
        rerating.0.0.0.1: ""
        rsm.0.0.0.1: ""
        super_user.0.0.0.1: ""
        ui_client.0.0.0.1: ""
        ece.0.0.0.1: ""

    wallet:
        client: "REJhZG1pbl8xMjMj"
        server: "REJhZG1pbl8xMjMj"
        root: "REJhZG1pbl8xMjMj"


    cm:
        isEnabled: true
        deployment:
            imageName: cm
            imageTag: wp2-3
    eai_js:
        deployment:
            imageName: eai_js
            imageTag: 15.1.0.0.0

    dm_oracle:
        isEnabled: true
        deployment:
            replicaCount: 1
            imageName: dm_oracle
            imageTag: 15.1.0.0.0


    storage_class:
        create: false
        name: brm-shared-vol
        parameters: {}

    db:
        deployment:
            imageName: init_db
            imageTag: 15.1.0.0.0
        host: ${DBHOST}
        port: 1521
        service: ${DBSERVICE}
        sslMode: NO
        # Password of the DB SSL wallet. Required if sslMode is set to "ONE_WAY"
        walletPassword: REJhZG1pbl8xMjM
        # Specify the DB SSL wallet type: pkcs12 or sso
        walletType: sso
        schemauser: pin
        schemapass: ${PINPASS}
        schematablespace: pin00
        indextablespace: pinx00
        pipelineschemauser: pin
        pipelineschemapass: ${PINPASS}
        pipelineschematablespace: pin00
        pipelineindextablespace: pinx00

    realtimepipe:
        isEnabled: true
        deployment:
            imageName: realtimepipe
            imageTag: 15.1.0.0.0

    rel_daemon:
      isEnabled: true
      job:
        extConfigScriptsCM:
        isEnabled: false
        dbNumber: 0.0.0.1
        jvmOpts: "-Xms256m -Xmx2048m -XX:+UseContainerSupport -Djava.security.egd=file:/dev/./urandom"
      deployment:
        imageName: rel_daemon
        imageTag: 15.1.0.0.0

      serverPod:
          podSecurityContext:
              fsGroup: 1000
              runAsUser: 1000
              fsGroupChangePolicy: "OnRootMismatch"

    dm_eai:
      isEnabled: true

    batchpipe:
        isEnabled: true

    formatter:
      isEnabled: true
      deployment:
        imageName: formatter
        imageTag: 15.1.0.0.0
        replicaCount: 1
        logLevel: 1
        jsLogLevel: 1
        pxsltLogLevel: 1
        jvmOpts: "-Xms32m -Xmx256m -ss1m -XX:+UseContainerSupport -Djava.security.egd=file:/dev/./urandom"
      resources: {}

    cmt:
        # Set enabled: true for running pin_cmt
        enabled: true

    config_jobs:
        deployment:
            imageName: brm_apps
            imageTag: 15.1.0.0.0
        # Set run_apps: true for running custom scripts
        run_apps: true

    brm_apps:
        job:
            isEnabled: true
        deployment:
            isEnabled: true
            imageName: brm_apps
            imageTag: 15.1.0.0.0
    wsm:
        deployment:
            weblogic:
                isEnabled: true
                imageName: brm_wsm_wls
                initImageName: brm_wsm_wl_init
                imageTag: 15.1.0.0.0
                username: d2VibG9naWM=
                password: d2VibG9naWMxMjM=
                replicaCount: 1
                adminServerNodePort: 30077
                log_enabled: false
                minPoolSize: 1
                maxPoolSize: 8
                poolTimeout: 30000
                jvmOpts: "-Dweblogic.StdoutDebugEnabled=false -Dweblogic.security.remoteAnonymousRMIT3Enabled=false -Dweblogic.security.remoteAnonymousRMIIIOPEnabled=false"
                userMemArgs: "-Xms768m -Xmx2048m -XX:+UseContainerSupport -Djava.security.egd=file:/dev/./urandom"
                serverStartPolicy: IF_NEEDED



    brm_sdk:
        isEnabled: true
        extCustomScriptsCM:
        deployment:
            imageName: brm_sdk
            imageTag: 15.1.0.0.0


# This section is for forwarding the logs to a log management system
# Applicable only for services running forwarder app as sidecar
logging:
    isEnabled: false
    fluentd:
        imageName:
        resources: {}
        conf:
            ocbrm:
            wsm:
            ocbc:
            ocboc:
            ocpdc:
            ocpcc:
            webhook:

webhook:
    # flag to enable webhook
    isEnabled: false
    # log directory for webhook application
    logPath: /u01/log
    # log level, Available options are CRITICAL, ERROR, INFO, DEBUG, WARNING and NOTSET
    logLevel: INFO
    extScriptsCM:
    deployment:
        # webhook application image name
        imageName: webhook
        # webhook application image tag
        imageTag: 15.1.0.0.0

    scripts:
        # scripts mount path
        mountPath: /u01/script
    # weblogic operator details
    wop:
        # namespace of weblogic operator
        namespace: wko
        # service account of weblogic operator
        sa: default
        # internal operator certficate present in operator configmap
        internalOperatorCert:
    # extra alert details in json format
    jsonConfig:

ocpdc:
    isEnabled: true
    deployment:
        fmw:
        #FMW image should be of 14.1.2.0 with OL9-JDK21
          imageRepository: "fra.ocir.io/fry4fxlvxkjt/communications_monetization/"
          imageName: "fmw-infrastructure"
          imageTag: ":14.1.2.0-jdk21-ol9"
        imageName: "pdc"
        # For non-empty tag, ":" MUST be perpended
        imageTag: ":15.1.0.0.0"

     # keys will take precedence than Values.ocpdc.nodeSelector or Values.ocpdc.affinity.
    nodeSelector:
      env: cts
    affinity: {}

    configEnv:
        rcuPrefix: rcupdcpoc
        dbHostName: ${DBHOST}
        dbPort: 1521
        dbService: ${DBSERVICE}
        # Transformation keys
        transformation:
            persistOutFiles: "disabled"
            nodeSelector: {}
            affinity: {}
        # Seed Data keys
        seedData:
            # Mandatory: Load Sample Balance Element after successful PDC deployment.
            # Note Balance Element will not be overwritten if already exists.
            BE: "true"
            # Mandatory: Load Sample RUM after successful PDC deployment.
            # Note RUM will not be overwritten if already exists.
            RUM: "true"
        # PDC Import-Export JOB keys
        importExport:
            IE_Operation: "import"
            IE_Component: "pricing"
            IE_File_OR_Dir_Name: "dopost_1mnd.xml"
            extraCmdLineArgs: "-ignoreID -ow"
            logLevel: "WARNING"
            persistIELogs: "failed"
            # Schedule Rule to deploy Import-Export POD on particular node by using nodeSelector or affinity
            nodeSelector: {}
            affinity: {}
       # SyncPDC keys
        syncPDC:
            enrichmentFileName:
            runSyncPDC: "true"
        # Schedule Rule to deploy SyncPDC POD on particular node by using nodeSelector or affinity
            nodeSelector: {}
            affinity: {}
     # PDC Secret Password keys
    secretValue:
        name: "pdc-secret-env"
        # PDC Application Wallet and PDC BRM Integration Wallet password
        walletPassword: REJhZG1pbl8xMjMj
ocpdcrsm:
    isEnabled: true
    deployment:
        imageName: "pdcrsm"
        imageTag: ":15.1.0.0.0"

    service:
        name: "pdcrsm"
        #Set type to NodePort to deploy 'pdcrsm' as a NodePort service.
        type: "ClusterIP"
        nodePort:
ocboc:
    boc:
        isEnabled: true
        deployment:
            app:
                imageName: boc
                imageTag: :15.1.0.0.0
            fmw:
                imageRepository: "fra.ocir.io/fry4fxlvxkjt/communications_monetization/"
                imageName: fmw-infrastructure
                imageTag: :14.1.2.0-jdk21-ol9

        configEnv:
            # Host name or IP Address of Database Server
            dbHost: ${DBHOST}
            # Port number of Database Server
            dbPort: 1521
            # Service Name which identifies DB
            dbServiceName: ${DBSERVICE}
            # Specify the SSLMode : "NO", "ONE_WAY"
            dbSSLMode: "NO"
            dbWalletType: sso
            # Production setup must use OPSS (true) only
            isOPSS: false
            # Private Key Alias of the keystore
            keystoreAlias:
            # Name of the secret containing Identity and Trust keystore files
            extKeystoreSecret:
            # File type of SSL Identity and Trust store, either "PKCS12" or "JKS"
            keystoreType: PKCS12
            # Runs schema upgrade. One of true, false
            runUpgrade: false
        secretVal:
            # Password to wallet storing sensitive data for BRM connection
            walletPassword:
            # StorePass of Trust Keystore
            keystoreTrustPassword:
        wop:
            domainUID: boc-domain
            totalManagedServers: 5
            initialServerCount: 2
            # NodePort where admin-server's http service will be accessible, Example: 30811
            adminChannelPort: 30811
            # serverStartPolicy legal values are "NEVER", "IF_NEEDED", or "ADMIN_ONLY"
            # This determines which WebLogic Servers the Operator will start up when it discovers this Domain
            # - "NEVER" will not start any server in the domain
            # - "ADMIN_ONLY" will start up only the administration server (no managed servers will be started)
            # - "IF_NEEDED" will start all non-clustered servers, including the administration server and clustered servers up to the replica count
            serverStartPolicy: 'IF_NEEDED'
            # Force rolling restart of all server pods. Change to any value other than current to trigger the action.
            restartVersion: "1"
            # Force domain introspection on change in domain configuration. Change to any value other than current to trigger the action.
            introspectVersion: "1"

        nodeSelector:
          env: cts
        affinity: {}
        #serverPod: {}
        serverPod:
            podSecurityContext:
                fsGroup: 1000
                runAsUser: 1000
                fsGroupChangePolicy: "OnRootMismatch"
ocbc:
    bc:
        isEnabled: true
        deployment:
            app:
                imageName: billingcare
                imageTag: :15.1.0.0.0
            fmw:
                imageRepository: fra.ocir.io/fry4fxlvxkjt/communications_monetization/
                imageName: fmw-infrastructure
                imageTag: :14.1.2.0-jdk21-ol9

        configEnv:
            httpPort: 7011
            isOPSS: false
            # Private Key Alias of the keystore
            keystoreAlias:
            # Name of the secret containing Identity and Trust keystore files
            extKeystoreSecret:
            # File type of SSL Identity and Trust store, either "PKCS12" or "JKS"
            keystoreType: PKCS12
            # Specify the SSLMode : "NO", "ONE_WAY"
            dbSSLMode:
            # Specify the DB SSL wallet type: SSO
            dbWalletType:
            # Name of the secret containing SSL DB wallet
            extDBSSLWalletSecret: ""

        secretVal:
            # Password to wallet storing sensitive data for BRM connection
            walletPassword:
            # Password of the BIP Instance (configEnv.bipUserId)
            bipPassword:
            # StorePass of Trust Keystore
            keystoreTrustPassword:
        wop:
            domainUID: billingcare-domain
            totalManagedServers: 5
            initialServerCount: 2
            adminChannelPort: 30711
            serverStartPolicy: 'IF_NEEDED'
            restartVersion: "1"
            introspectVersion: "1"

        # Define rules for scheduling WebLogic Server pods on particular nodes
        # either by using nodeSelector or affinity
        nodeSelector:
          env: cts
        affinity: {}
        # Details to inject at domain server pod level
        serverPod:
            podSecurityContext:
                fsGroup: 1000
                runAsUser: 1000
                fsGroupChangePolicy: "OnRootMismatch"
    # Values used for Billing Care REST API and its domain
    bcws:
        isEnabled: true
        deployment:
            app:
                imageName: bcws
                imageTag: :15.1.0.0.0
            fmw:
                imageRepository: fra.ocir.io/fry4fxlvxkjt/communications_monetization/
                imageName: fmw-infrastructure
                imageTag: :14.1.2.0-jdk21-ol9
            sdk:
                # Name of the billingcare sdk image
                imageName: billingcare_sdk
                # Tag associated with image, generally, patch-set number
                # For non-empty tag, ":" MUST be prepended
                imageTag: :wp2
                # Image pull policy. One of Always, Never, IfNotPresent
                imagePullPolicy: IfNotPresent
        sdk:
            # A boolean value to additionally deploy your customizations to
            # override application behavior
            isEnabled: true
            # Name of SDK to appear in deployment list
            deployName: BillingCareCustomizations


        configEnv:
            # Container's port for access to WebLogic Domain over HTTP
            httpPort: 7011
            # Create an OPSS or non-OPSS domain. One of true, false
            # Production setup must use OPSS (true) only
            isOPSS: false
            # Private Keylias of the keystore
            keystoreAlias:
            # Name of the secret containing Identity and Trust keystore files
            extKeystoreSecret:
            # File type of SSL Identity and Trust store, either "PKCS12" or "JKS"
            keystoreType: PKCS12
            # Specify the SSLMode : "NO", "ONE_WAY"
            dbSSLMode: "NO"
            # Specify the DB SSL wallet type: SSO
            dbWalletType: "SSO"
            # Name of the secret containing SSL DB wallet
            extDBSSLWalletSecret: ""
            # URL to BIP Server
            # Example: http(s)://__HOST__:__PORT__/xmlpserver/services/PublicReportService_v11
            bipUrl: __BIP_URL__
            # Name of user with access to BIP instance
            bipUserId: __BIP_USER_ID__


        wop:
            domainUID: bcws-domain
            totalManagedServers: 5
            initialServerCount: 2
            adminChannelPort: 30721
            serverStartPolicy: 'IF_NEEDED'
            restartVersion: "1"
            introspectVersion: "1"

        serverPod:
            podSecurityContext:
                fsGroup: 1000
                runAsUser: 1000
                fsGroupChangePolicy: "OnRootMismatch"

ocpcc:
    pcc:
        # all its associated resources
        isEnabled: false


ocrsm:

    rsm:
        isEnabled: true
        deployment:
            imageName: brm-rest-services-manager
            imageTag: :15.1.0.0.0
            sdk:
                # SDK image name
                imageName: java-runtime-21
                # SDK image tag, For non-empty tag, ":" MUST be prepended
                imageTag: :1.0.5
        configEnv:
            # Name of this configmap
            name: brm-rest-services-manager-env-configmap
            # Http container port on which application will be deployed
            httpPort: 9090
            # Https container port on which application will be deployed
            httpsPort: 8080
            # Admin port for Health, Metrics and other admin related activities
            adminPort: 9060
            rsmCertificateFileName: rsmkey.p12
        secretVal:
            # Name of the secret which stores all password
            name: brm-rest-services-manger-env-secret
            # BRM Rest Service Manager Certificate Password
            rsmCertificatePassword:
            # BRM Infranet Wallet Password used to store BRM connection details to wallet, Wallet password should have one alpha and numeric value.
            brmInfranetWalletPassword:
            # BIP Password
            bipPassword:
            # Client Secret required for token based authentication
            clientSecret:
            #Trust store file password
            trustStorePassword:

        service:
            # Name of Service
            name: brm-rest-services-manager
            # Service type
            type: ClusterIP
