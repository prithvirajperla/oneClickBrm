# Copyright (c) 2023, 2025, Oracle and/or its affiliates.
#Environment Specific File"

# For non-empty repository, "/" MUST be appended
imageRepository: "fra.ocir.io/fry4fxlvxkjt/communications_monetization/"
imagePullSecrets:
    - name: "brm-registry"
uniPass: "Q1RTdHJhaW5lcl8xMjMj"

db:
    sslMode: "NO"
    host:  ${DBHOST}
    port: 1521
    user: sys
    password: "${DBPASS}"
    serviceName:  ${DBSERVICE}
    role: sysdba
    walletPassword: "Q1RTdHJhaW5lcl8xMjMj"
    walletType: sso
ocbrm:
    LOG_LEVEL: 3
    root_key_rotate: false
    brm_root_pass: "Q1RTdHJhaW5lcl8xMjMj"
    rotate_password: false
    new_brm_root_password: ""
    rotate_brm_role_passwords: false
    # Set the passwords for brm users/roles
    brm_role_pass:
        acct_recv.0.0.0.1: "Q1RTdHJhaW5lcl8xMjMj"
        bc_client.0.0.0.1: "Q1RTdHJhaW5lcl8xMjMj"
        bill_inv_pymt_sub.0.0.0.1: "Q1RTdHJhaW5lcl8xMjMj"
        billing.0.0.0.1: "Q1RTdHJhaW5lcl8xMjMj"
        boc_client.0.0.0.1: "Q1RTdHJhaW5lcl8xMjMj"
        collections.0.0.0.1: "Q1RTdHJhaW5lcl8xMjMj"
        crypt_utils.0.0.0.1: "Q1RTdHJhaW5lcl8xMjMj"
        cust_center.0.0.0.1: "Q1RTdHJhaW5lcl8xMjMj"
        cust_mgnt.0.0.0.1: "Q1RTdHJhaW5lcl8xMjMj"
        invoicing.0.0.0.1: "Q1RTdHJhaW5lcl8xMjMj"
        java_client.0.0.0.1: "Q1RTdHJhaW5lcl8xMjMj"
        load_utils.0.0.0.1: "Q1RTdHJhaW5lcl8xMjMj"
        payments.0.0.0.1: "Q1RTdHJhaW5lcl8xMjMj"
        pcc_client.0.0.0.1: "Q1RTdHJhaW5lcl8xMjMj"
        rerating.0.0.0.1: "Q1RTdHJhaW5lcl8xMjMj"
        rsm.0.0.0.1: "Q1RTdHJhaW5lcl8xMjMj"
        super_user.0.0.0.1: "Q1RTdHJhaW5lcl8xMjMj"
        ui_client.0.0.0.1: "Q1RTdHJhaW5lcl8xMjMj"
        ece.0.0.0.1: "Q1RTdHJhaW5lcl8xMjMj"

    wallet:
        client: "Q1RTdHJhaW5lcl8xMjMj"
        server: "Q1RTdHJhaW5lcl8xMjMj"
        root: "Q1RTdHJhaW5lcl8xMjMj"

    cm:
        service:
            type: "NodePort"
            nodePort: 30455
    virtual_time:
        enabled: true
        sync_pvt_time: 60
        volume:
            storage: 50Mi
            createOption: {}

    cmt:
        # Set enabled: true for running pin_cmt
        enabled: true
        volume:
            storage: 2Gi
            createOption: {}

    storage_class:
        create: false
        name: brm-shared-storage
        parameters: {}

    db:
        deployment:
            imageName: init_db
            imageTag: 15.1.0.0.0
        host:  ${DBHOST}
        port: 1521
        service:  ${DBSERVICE}
        sslMode: NO
        # Password of the DB SSL wallet. Required if sslMode is set to "ONE_WAY"
        walletPassword: "Q1RTdHJhaW5lcl8xMjMj"
        # Specify the DB SSL wallet type: pkcs12 or sso
        walletType: sso
        schemauser: pin
        schemapass: "${PINPASS}"
        schematablespace: pin00
        indextablespace: pinx00
        pipelineschemauser: pin
        pipelineschemapass: "${PINPASS}"
        pipelineschematablespace: pin00
        pipelineindextablespace: pinx00

    wsm:
        deployment:
            weblogic:
                isEnabled: false
                imageName: brm_wsm_wls
                initImageName: brm_wsm_wl_init
                imageTag: 15.1.0.0.0
                username: d2VibG9naWM=
                password: d2VibG9naWMxMjM=
                replicaCount: 1
                adminServerNodePort: 30408



ocpdc:
    isEnabled: true
     # keys will take precedence than Values.ocpdc.nodeSelector or Values.ocpdc.affinity.
    nodeSelector:
      env: cts
    affinity: {}

    configEnv:
        rcuPrefix: rcupdcdev3
        dbHostName:  ${DBHOST}
        dbPort: 1521
        dbService:  ${DBSERVICE}
        transformation:
            persistOutFiles: "enabled"
            nodeSelector: {}
            affinity: {}
        importExport:
            IE_Operation: "export"
            IE_Component: "pricing"
            #IE_File_OR_Dir_Name: "Wholesale"
            #IE_File_OR_Dir_Name: "export_metadata2025-07-25_12-14-24.xml"
            #extraCmdLineArgs: "-ignoreID -ow"
            extraCmdLineArgs: "-expRefs"
            logLevel: "INFO"
            persistIELogs: "failed"
            # Schedule Rule to deploy Import-Export POD on particular node by using nodeSelector or affinity
            nodeSelector: {}
            affinity: {}
       # SyncPDC keys
        syncPDC:
            nodeSelector: {}
            affinity: {}
     # PDC Secret Password keys
    secretValue:
        name: "pdc-secret-env"
        # PDC Application Wallet and PDC BRM Integration Wallet password
        walletPassword: "Q1RTdHJhaW5lcl8xMjMj"
ocpdcrsm:
    service:
        name: "pdcrsm"
        #Set type to NodePort to deploy 'pdcrsm' as a NodePort service.
        type: "ClusterIP"
        nodePort: 30409


ocboc:
    boc:
        configEnv:
            # Host name or IP Address of Database Server
            dbHost:  ${DBHOST}
            # Port number of Database Server
            dbPort: 1521
            # Service Name which identifies DB
            dbServiceName:  ${DBSERVICE}
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
            walletPassword: "Q1RTdHJhaW5lcl8xMjMj"
            # StorePass of Trust Keystore
            keystoreTrustPassword: "Q1RTdHJhaW5lcl8xMjMj"
        wop:
            domainUID: boc-domain
            totalManagedServers: 5
            initialServerCount: 1
            # NodePort where admin-server's http service will be accessible, Example: 30811
            adminChannelPort: 30404
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
            dbSSLMode: NO
            # Specify the DB SSL wallet type: SSO
            dbWalletType: "SSO"
            # Name of the secret containing SSL DB wallet
            extDBSSLWalletSecret: ""

        secretVal:
            # Password to wallet storing sensitive data for BRM connection
            walletPassword: "Q1RTdHJhaW5lcl8xMjMj"
            # Password of the BIP Instance (configEnv.bipUserId)
            bipPassword:
            # StorePass of Trust Keystore
            keystoreTrustPassword: "Q1RTdHJhaW5lcl8xMjMj"
        wop:
            domainUID: billingcare-domain
            totalManagedServers: 5
            initialServerCount: 1
            adminChannelPort: 30405
            serverStartPolicy: 'IF_NEEDED'

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
        secretVal:
            # Password to wallet storing sensitive data for BRM connection
            walletPassword: "Q1RTdHJhaW5lcl8xMjMj"
            # Password of the BIP Instance (configEnv.bipUserId)
            bipPassword:
            # StorePass of Trust Keystore
            keystoreTrustPassword: "Q1RTdHJhaW5lcl8xMjMj"
        wop:
            totalManagedServers: 5
            initialServerCount: 1
            adminChannelPort: 30406
            serverStartPolicy: 'IF_NEEDED'
            restartVersion: "1"
            introspectVersion: "1"

ocrsm:

    rsm:
        configEnv:
            # Name of this configmap
            name: brm-rest-services-manager-env-configmap
            # Http container port on which application will be deployed
            httpPort: 9090
            # Https container port on which application will be deployed
            httpsPort: 8080
            # Admin port for Health, Metrics and other admin related activities
            adminPort: 9060
            baseURL: www.dbssrm-dev3-ocrsm.com
        secretVal:
            # Name of the secret which stores all password
            name: brm-rest-services-manger-env-secret
            # BRM Rest Service Manager Certificate Password
            rsmCertificatePassword: "Q1RTdHJhaW5lcl8xMjMj"
            # BRM Infranet Wallet Password used to store BRM connection details to wallet, Wallet password should have one alpha and numeric value.
            brmInfranetWalletPassword: "Q1RTdHJhaW5lcl8xMjMj"
            # BIP Password
            bipPassword:
            # Client Secret required for token based authentication
            clientSecret: "Q1RTdHJhaW5lcl8xMjMj"
            #Trust store file password
            trustStorePassword: "Q1RTdHJhaW5lcl8xMjMj"
        secretVal:
            # Name of the secret which stores all password
            name: brm-rest-services-manger-env-secret
            # BRM Rest Service Manager Certificate Password
            rsmCertificatePassword: "Q1RTdHJhaW5lcl8xMjMj"
            # BRM Infranet Wallet Password used to store BRM connection details to wallet, Wallet password should have one alpha and numeric value.
            brmInfranetWalletPassword: "Q1RTdHJhaW5lcl8xMjMj"
            # BIP Password
            bipPassword:
            # Client Secret required for token based authentication
            clientSecret: "Q1RTdHJhaW5lcl8xMjMj"
            #Trust store file password
            trustStorePassword: "Q1RTdHJhaW5lcl8xMjMj"
        service:
            # Name of Service
            name: brm-rest-services-manager
            # Service type
            type: ClusterIP