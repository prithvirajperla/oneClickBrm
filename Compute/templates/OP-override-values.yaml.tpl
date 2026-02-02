# Copyright (c) 2023, 2025, Oracle and/or its affiliates.

# For non-empty repository, "/" MUST be appended
imageRepository: "fra.ocir.io/fry4fxlvxkjt/communications_monetization/"
imagePullSecrets:
    # For multiple pull secrets add the name: "secret" below again
    - name: "brm-registry"
uniPass: "REJhZG1pbl8xMjMj"

db:
    sslMode: "ONE_WAY"
    extDBSSLWalletSecret: ""
    host: ${DBHOST}
    port: 1521
    user: sys
    password: ${DBPASS}
    serviceName: ${DBSERVICE}
    role: sysdba
    walletPassword: REJhZG1pbl8xMjMj
    walletType: sso


ocbrm:

    ece_deployed: true
    pdc_deployed: true
    TZ: UTC
    LOG_LEVEL: 1
    # SSL is enabled when set to true and disabled when set to false
    isSSLEnabled: true
    # Disables SSL from CM to DM/EM. When set to true set isSSLEnabled = true
    cmSSLTermination: false
    # Set customSSLWallet to true, when using custom TLS certificate for CM. Set cmSSLTermination to true as well.
    # The wallet containing the custom TLS certificate needs to placed at top level of the helm chart
    customSSLWallet: false
    extCustomSSLWalletSecret:
    # To enable autoscaling set isHPAEnabled to true.
    isHPAEnabled: false
    # To refresh the PCM context to accept request on new CM
    refreshInterval:
    # Time elapsed before the pod is terminated, increase it for long running transaction
    terminationGracePeriodSeconds:
    # Time spent waiting for socket re-connection
    pcpReconnectDelayOnSocketError:
    # Time for retrying the connect , when pcp_connect fails
    pcpConnectRetryDelayOnError:
    # To enable Security Context in the cluster set EnableSecurityContext to true.
    EnableSecurityContext: false
    # Set root_key_rotate: true to rotate BRM Root Key
    root_key_rotate: false
    brm_root_pass:
    # Set rotate_password: true to change BRM Root Password
    rotate_password: false
    new_brm_root_password: ""
    # To rotate passwords for BRM users/roles set rotate_brm_role_passwords to true and,
    # provide current password with old_ prefix example: old_acct_recv.0.0.0.1: "" and the new password to be updated as acct_recv.0.0.0.1: ""
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
            replicaCount: 1
            imageName: cm
            imageTag: 15.1.0.0.0
            #Set enable_publish to 1 to enables publishing of business events through  EAI Framework
            enable_publish: 0
            # Enable enrichment in published message with notification preference.
            enable_prefs_enrichment: false
            # List of publishers with enrichment enabled.
            prefs_enabled_publisher_list: 0.0.9.6
            # Location of where to get the phone number for subscribers.
            prefs_phone_no_location: 0
            #Set provisioning_enabled to true to enable provisioning
            provisioning_enabled: false
            #Set simulate_agent to 0 to publish service orders
            simulate_agent: 1
            perflib_enabled: false
        service:
            type: ClusterIP
            #Below entry is used to specify CM's TLS certificate Subject Alternative Name
            #Example serviceFqdn: dns:node1.brm.com,dns:node2.brm.com,ip:127.0.0.1
            serviceFqdn: dns:ocbrm.example.com
        custom_files:
            enable: false
            extCustomFilesCM:
        resources: {}
        hpaValues:
            minReplica: 2
            maxReplica: 4
            targetCpu: 80
            targetMemory: 80

    custom_job_files:
        volume:
            storage: 50Mi

    eai_js:
        deployment:
            imageName: eai_js
            imageTag: 15.1.0.0.0
            eaiConfigFile:
            jvmOpts: "-Xms256m -Xmx512m -ss1m -XX:+UseContainerSupport -Djava.security.egd=file:/dev/./urandom"
        extPayloadCM:
        resources: {}

    dm_oracle:
        isEnabled: true
        deployment:
            replicaCount: 1
            imageName: dm_oracle
            imageTag: 15.1.0.0.0
            perflib_enabled: false
            DM_DEBUG: "0x0"
            DM_DEBUG2: "0x0"
            DM_DEBUG3: "0x0"
            DM_DEBUG5: "0x0"
        config:
            totalFrontEnds: 4
            totalBackEnds: 6
            connectionsPerFrontEnd: 16
            totalTransBackEnds: 4
            dmSequenceCacheSize: "10000"
            maxStatementCache: 256
            sharedMemoryBigSize: "268435456"
            sharedMemorySegmentSize: "2147483648"
        secondaryConfig:
            totalFrontEnds: 4
            totalBackEnds: 6
            connectionsPerFrontEnd: 16
            totalTransBackEnds: 4
            dmSequenceCacheSize: "10000"
            maxStatementCache: 256
            sharedMemoryBigSize: "268435456"
            sharedMemorySegmentSize: "2147483648"
        resources: {}
        hpaValues:
            minReplica: 2
            maxReplica: 4
            targetCpu: 80
            targetMemory: 80

    dm_kafka:
        isEnabled: false
        kafkaAsyncMode: false
        maxBlock: 3000
        extKafkaKeystoreSecret:
        deployment:
            imageName: dm_kafka
            imageTag: 15.1.0.0.0
            replicaCount: 1
            jvmOpts: "-Xms32m -Xmx256m -ss1m -XX:+UseContainerSupport -Djava.security.egd=file:/dev/./urandom"
            kafka_bootstrap_server_list: ece-kafka:9093
            poolSize: 64
            topicName: BRMTopic
            topicFormat: XML
            topicStyle: CamelCase
            isSecurityEnabled: false
            trustStorePassword:
            keyStorePassword:
            keyPassword:
            password:
        volume:
            storage: 50Mi
            createOption: {}
        resources: {}
        hpaValues:
            minReplica: 2
            maxReplica: 4
            targetCpu: 80
            targetMemory: 80

    dm_email:
        isEnabled: false
        deployment:
            replicaCount: 1
            imageName: dm_email
            imageTag: 15.1.0.0.0
            smtpServer: example.us.oracle.com
        config:
            totalFrontEnds: 4
            totalBackEnds: 8
            connectionsPerFrontEnd: 16
            sharedMemoryBigSize: 512k
            sharedMemorySize: 4m
        resources: {}

    dm_invoice:
        isEnabled: false
        deployment:
            replicaCount: 1
            imageName: dm_invoice
            imageTag: 15.1.0.0.0
        config:
            totalFrontEnds: 2
            totalBackEnds: 6
            connectionsPerFrontEnd: 16
            totalTransBackEnds: 4
            dmSequenceCacheSize: "10000"
            maxStatementCache: 256
            sharedMemoryBigSize: "268435456"
            sharedMemorySegmentSize: "2147483648"
        resources: {}

    dm_ldap:
        isEnabled: false
        deployment:
            replicaCount: 1
            imageName: dm_ldap
            imageTag: 15.1.0.0.0
            dirserverpassword:
        resources: {}

    dm_prov_telco:
        isEnabled: false
        deployment:
            replicaCount: 1
            imageName: dm_prov_telco
            imageTag: 15.1.0.0.0
        config:
            totalFrontEnds: 4
            totalBackEnds: 8
            connectionsPerFrontEnd: 16
            connectionsPerBackEnd: 8
            sharedMemoryBigSize: "2097152"
            sharedMemorySize: "33554432"
        volume:
            storage: 50Mi
            createOption: {}
        resources: {}

    # Update the provisioner name
    dynamic_provisioner:
        provisioner: oracle.com/oci

    storage_class:
        create: true
        name: green
        parameters: {}

    virtual_time:
        enabled: false
        sync_pvt_time: 60
        volume:
            storage: 50Mi
            createOption: {}
    db:
        deployment:
            imageName: init_db
            imageTag: 15.1.0.0.0
        host: ${DBHOST}
        port: 1521
        service: ${DBSERVICE}
        # Specifies if DB is SSL enabled. Supported values are NO , ONE_WAY and TWO_WAY
        sslMode: ONE_WAY
        extDBSSLWalletSecret: ""
        # Password of the DB SSL wallet. Required if sslMode is set to "ONE_WAY"
        walletPassword:
        # Specify the DB SSL wallet type: pkcs12 or sso
        walletType: sso
        # Set enable_partition: No , if partitioning is disabled at database level or want to skip partitioning
        enable_partition: 'Yes'
        # Set storage_model to determine size of BRM database tablespaces
        storage_model: 'Large'
        schemauser: pin
        schemapass: ${PINPASS}
        schematablespace: pin
        indextablespace: pinx
        nls_lang: AMERICAN_AMERICA.AL32UTF8
        pipelineschemauser: 
        pipelineschemapass:
        pipelineschematablespace:
        pipelineindextablespace:
        # uncomment the below for multi-schema setup and add new block 'secondaryN' for more than 1 secondary schema
        #multiSchemas:
            #secondary1:
               #deploy: true
               #host:
               #port:
               #service:
               #schemauser:
               #schemapass:
               #schematablespace:
               #indextablespace:
        resources: {}

    upgrade:
        deployment:
            imageName: upgrade
            imageTag: 15.1.0.0.0

    perflib:
        deployment:
            imageName: perflib
            imageTag: 15.1.0.0.0
            #Set persistPerflibLogs to True if you want to store perflib timing files into the DB
            persistPerflibLogs: false
            jvmOpts: "-Xms128m -Xmx256m"
        resources: {}

    dm_fusa:
        isEnabled: false
        deployment:
            imageName: dm_fusa
            imageTag: 15.1.0.0.0
            simulatorTag: 15.1.0.0.0
            dmf_sid_pwd: ""
            dmf_pid_pwd: ""
        volume:
            storage: 50Mi
            createOption: {}
        resources: {}

    dm_vertex:
        isEnabled: false
        deployment:
            replicaCount: 1
            imageName: dm_vertex
            imageTag: 15.1.0.0.0
            quantum_db_password:
            ctqCfg: /oms/vertex/64bit/cfg
            ctqCfgName: CTQ Test
            ctqSmObj: ./dm_vertex_ctq30206.so
        resources: {}

    realtimepipe:
        isEnabled: true
        deployment:
            replicaCount: 1
            imageName: realtimepipe
            imageTag: 15.1.0.0.0
            rtp_num_thread: 8
            rtp_num_pipe: 2
            discount_trace: True
            console_discount_trace: True
            loglevel: major
            SemaphoreEnable: True
        volume:
            storage: 50Mi
            createOption: {}
        nodeSelector: {}
        resources: {}
        hpaValues:
            minReplica: 2
            maxReplica: 4
            targetCpu: 80
            targetMemory: 80

    batch_controller:
        isEnabled: false
        deployment:
            replicaCount: 1
            imageName: batch_controller
            imageTag: 15.1.0.0.0
            jvmOpts: "-Xms64m -Xmx256m -XX:+UseContainerSupport -Djava.security.egd=file:/dev/./urandom"
        volume:
            input:
                storage: 50Mi
                createOption: {}
            archive:
                storage: 50Mi
                createOption: {}
            reject:
                storage: 50Mi
                createOption: {}
        nodeSelector: {}
        resources: {}
        hpaValues:
            minReplica: 2
            maxReplica: 4
            targetCpu: 80
            targetMemory: 80

    dm_eai:
      isEnabled: false
      deployment:
        imageName: dm_eai
        imageTag: 15.1.0.0.0
        replicaCount: 1
      resources: {}
      hpaValues:
        minReplica: 2
        maxReplica: 4
        targetCpu: 80
        targetMemory: 80

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
        replicaCount: 1
        jvmOpts: "-Xms256m -Xmx2048m -XX:+UseContainerSupport -Djava.security.egd=file:/dev/./urandom"
      volume:
        reject:
          storage: 1Gi
          createOption: {}
        archive:
          storage: 1Gi
          createOption: {}
        input:
          storage: 1Gi
          createOption: {}
      nodeSelector: {}
      resources: {}
      hpaValues:
        minReplica: 2
        maxReplica: 4
        targetCpu: 80
        targetMemory: 80

    rem:
      logging:
        logToFile: false
        log4j2:
          logger:
            brmRatedeventmanager: INFO
            brmRatedeventmanagerDiagnostic: INFO
            root: INFO
      isEnabled: false
      deployment:
        streamingEnabled: false
        topicName: RatedEvents
        jvmOpts: "-Xms256m -Xmx2048m -XX:+UseContainerSupport -Djava.security.egd=file:/dev/./urandom"
        kafkaBootstrapServer: ece-kafka:9093
        imageName: rem
        imageTag: 15.1.0.0.0
      volume:
        input:
          storage: 1Gi
          createOption: {}
        reject:
          storage: 1Gi
          createOption: {}
        archive:
          storage: 1Gi
          createOption: {}
        data:
          storage: 100Mi
          createOption: {}
      nodeSelector: {}
      resources: {}
      hpaValues:
        minReplica: 2
        maxReplica: 4
        targetCpu: 80
        targetMemory: 80
      healthCheckPort: 8989

    rel_manager:
      job:
        extConfigScriptsCM:
        isEnabled: false
        dbNumber: 0.0.0.1
        jvmOpts: "-Xms256m -Xmx2048m -XX:+UseContainerSupport -Djava.security.egd=file:/dev/./urandom"
        logging:
          logToFile: false
          log4j2:
            logger:
              brmRatedeventmanager: INFO
              brmRelManager: INFO
              brmTableFormatter: INFO
              root: INFO
        resources: {}

    batchpipe:
        isEnabled: true
        deployment:
            imageName: batch_pipeline
            imageTag: 15.1.0.0.0
            discount_trace: True
            console_discount_trace: True
            loglevel: major
        volume:
            data:
                storage: 50Mi
                createOption: {}
            output:
                storage: 50Mi
                createOption: {}
            reject:
                storage: 50Mi
                createOption: {}
            log:
                storage: 100Mi
                createOption: {}
        nodeSelector: {}
        resources: {}

    roampipe:
        isEnabled: false
        deployment:
            imageName: roam_pipeline
            imageTag: 15.1.0.0.0
            discount_trace: True
            console_discount_trace: True
            loglevel: major
        volume:
            output:
                storage: 100Mi
                createOption: {}
            reject:
                storage: 100Mi
                createOption: {}
        nodeSelector: {}
        resources: {}

    formatter:
      isEnabled: false
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
        enabled: false
        volume:
            storage: 50Mi
            createOption: {}


    config_jobs:
        deployment:
            imageName: brm_apps
            imageTag: 15.1.0.0.0
        # Set run_apps: true for running custom scripts
        run_apps: false
        # Set isMultiSchema: true to trigger job for multiSchemas
        isMultiSchema: false
        # Increment restart_count to restart cm during helm upgrade
        restart_count: 0
        # Custom script name to be executed as part of Job
        script_name: loadme.sh
        configmap_path: /oms/load
        extCustomScriptsCM:
        resources: {}

    brm_apps:
        job:
            isEnabled: false
            # Set isMultiSchema: true to trigger job for multiSchemas
            isMultiSchema: false
            configmap_path: /oms/load
            script_name: loadme.sh
            jvmOpts: "-Xms32m -Xmx256m -ss1m -XX:+UseContainerSupport -Djava.security.egd=file:/dev/./urandom"
        extCustomScriptsCM:
        deployment:
            isEnabled: true
            imageName: brm_apps
            imageTag: 15.1.0.0.0
            replicaCount: 1
            jvmOpts: "-Xms32m -Xmx256m -ss1m -XX:+UseContainerSupport -Djava.security.egd=file:/dev/./urandom"
            pin_billd:
                mtaChildren: 5
                mtaPerBatch: 500
                mtaPerStep: 1000
                mtaFetchSize: 5000
                login_name: bill_inv_pymt_sub
                user_id: 412
            pin_export_price:
                mtaChildren: 5
                mtaPerBatch: 500
                mtaPerStep: 1000
                mtaFetchSize: 5000
                login_name: load_utils
                user_id: 413
            pin_inv:
                mtaChildren: 5
                mtaPerBatch: 500
                mtaPerStep: 1000
                mtaFetchSize: 5000
                login_name: invoicing
                user_id: 403
            pin_trial_bill:
                mtaChildren: 5
                mtaPerBatch: 500
                mtaPerStep: 1000
                mtaFetchSize: 5000
                login_name: billing
                user_id: 402
            pin_generate_analytics:
                mtaChildren: 5
                mtaPerBatch: 500
                mtaPerStep: 1000
                mtaFetchSize: 5000
                login_name: boc_client
                user_id: 414
            pin_gen_notifications:
                mtaChildren: 5
                mtaPerBatch: 500
                mtaPerStep: 1000
                mtaFetchSize: 5000
                login_name: bill_inv_pymt_sub
                user_id: 412
            pin_subscription:
                mtaChildren: 5
                mtaPerBatch: 500
                mtaPerStep: 1000
                mtaFetchSize: 5000
                login_name: root
                user_id: 1
            pin_rerate:
                mtaChildren: 5
                mtaPerBatch: 500
                mtaPerStep: 1000
                mtaFetchSize: 5000
                login_name: rerating
                user_id: 407
            pin_installments:
                mtaChildren: 5
                mtaPerBatch: 500
                mtaPerStep: 1000
                mtaFetchSize: 5000
                login_name: payments
                user_id: 404
            pin_deposits:
                mtaChildren: 5
                mtaPerBatch: 500
                mtaPerStep: 1000
                mtaFetchSize: 5000
                login_name: cust_mgnt
                user_id: 406
            pin_crypt:
                mtaChildren: 5
                mtaPerBatch: 500
                mtaPerStep: 1000
                mtaFetchSize: 5000
                login_name: crypt_utils
                user_id: 405
            pin_rate_change:
                login_name: rerating
                user_id: 407
            sample_handler:
                login_name: java_client
                user_id: 409
            pin_balance_transfer:
                mtaChildren: 5
                mtaPerBatch: 500
                mtaPerStep: 1000
                mtaFetchSize: 5000
                login_name: payments
                user_id: 404
            pin_collections:
                mtaChildren: 5
                mtaPerBatch: 500
                mtaPerStep: 1000
                mtaFetchSize: 5000
                login_name: collections
                user_id: 411
            pin_ra_check_thresholds:
                login_name: bill_inv_pymt_sub
                user_id: 412
            load_config:
                login_name: load_utils
                user_id: 413
            load_channel_config:
                login_name: load_utils
                user_id: 413
            exportapps:
                mtaChildren: 5
                mtaPerBatch: 500
                mtaPerStep: 1000
                mtaFetchSize: 5000
                login_name: load_utils
                user_id: 413
            pin_state_change:
                mtaChildren: 5
                mtaPerBatch: 500
                mtaPerStep: 1000
                mtaFetchSize: 5000
                login_name: cust_mgnt
                user_id: 406
            pin_unlock_service:
                login_name: cust_mgnt
                user_id: 406
            pin_remit:
                login_name: bill_inv_pymt_sub
                user_id: 412
            pin_bulk_adjust:
                mtaChildren: 5
                mtaPerBatch: 500
                mtaPerStep: 1000
                mtaFetchSize: 5000
                login_name: acct_recv
                user_id: 408
            pin_bill_handler:
                mtaChildren: 5
                mtaPerBatch: 500
                mtaPerStep: 1000
                mtaFetchSize: 5000
                login_name: java_client
                user_id: 409
            pin_ar_taxes:
                login_name: load_utils
                user_id: 413
            pin_event_extract:
                login_name: rerating
                user_id: 407
            pin_monitor:
                mtaChildren: 5
                mtaPerBatch: 500
                mtaPerStep: 1000
                mtaFetchSize: 5000
                login_name: cust_mgnt
                user_id: 406
            pin_ood_handler_process:
                mtaChildren: 5
                mtaPerBatch: 500
                mtaPerStep: 1000
                mtaFetchSize: 5000
                login_name: load_utils
                user_id: 413
            pin_ood_handler:
                mtaChildren: 5
                mtaPerBatch: 500
                mtaPerStep: 1000
                mtaFetchSize: 5000
                login_name: load_utils
                user_id: 413
            setup_scripts:
                login_name: load_utils
                user_id: 413
            pin_inv_doc_gen:
                bipServer: bipserver
                bipPort: 9502
                bipUsername: bipusername
                bipPassword: ""
                schedulerDBServer: dbhostname
                schedulerDBPort: 1521
                schedulerDBService: schedulerdbservice
                schedulerDBUsername: dbuser
                schedulerDBServiceCredentials: ""
                jdbcPoolSize: 5
                jdbcPoolMaxSize: 10
                securityCredentials: ""
            pin_job_executor:
                rendering: false
            amt:
                jvmOpts: "-Xms256m -Xmx2048m -XX:+UseContainerSupport -Djava.security.egd=file:/dev/./urandom"
        resources: {}
        hpaValues:
            minReplica: 2
            maxReplica: 4
            targetCpu: 80
            targetMemory: 80

    wsm:
        soap:
            isEnabled: false
            deployment:
                imageName: brm_wsm
                imageTag: 15.1.0.0.0
                replicaCount: 1
            service:
                type: ClusterIP
                resources: {}
            configEnv:
                port: 8080
                httpsPort: 8443
                inputValidationEnabled: true
                soapInputValidationReportOnly: false
                outputValidationEnabled: true
                soapOutputValidationReportOnly: false
                logLevel: WARNING
                tlsEnabled: false
                externalSecretName:
                clientAuth: OPTIONAL
                jvmOpts: ""
                keyStoreFileName:
                keyStoreAlias:
                trustStoreFileName:
                isOauthEnabled: false
                oauthCertificateName:
                outputDateFormat: "yyyy-MM-dd'T'HH:mm:ss"
                outputPrefixUnixTimestamp: false
                inputDateFormat: "yyyy-MM-dd'T'HH:mm:ss"
                inputPrefixUnixTimestamp: false
                outputNamespacePrefixSoap: "S"
                outputNamespacePrefixPayload: "brm"
                tracing:
                    service: BRM-WSM
                    enabled: true
                    protocol: http
                    host: localhost
                    port: 9411
                    path: /api/v2/spans
                    apiVersion: 2
            secrets:
                keyStorePassword:
                trustStorePassword:
            resources: {}

        deployment:
            weblogic:
                isEnabled: false
                imageName: brm_wsm_wls
                initImageName: brm_wsm_wl_init
                imageTag: 15.1.0.0.0
                username: d2VibG9naWM=
                password: d2VibG9naWMxMjM=
                replicaCount: 1
                adminServerNodePort:
                log_enabled: false
                minPoolSize: 1
                maxPoolSize: 8
                poolTimeout: 30000
                jvmOpts: "-Dweblogic.StdoutDebugEnabled=false -Dweblogic.security.remoteAnonymousRMIT3Enabled=false -Dweblogic.security.remoteAnonymousRMIIIOPEnabled=false"
                userMemArgs: "-Xms768m -Xmx2048m -XX:+UseContainerSupport -Djava.security.egd=file:/dev/./urandom"
                serverStartPolicy: IF_NEEDED
                monitoring:
                   isEnabled: false
                   imageRepository: ghcr.io/
                   # Name of the weblogic monitoring exporter image
                   imageName: oracle/weblogic-monitoring-exporter
                   imageTag: :2.1.4
                   # Image pull policy. One of Always, Never, IfNotPresent
                   imagePullPolicy: IfNotPresent
                   queries: []
                   resources: {}
                # Details of Identity Provider (IdP) managing OAuth 2.0 Tokens
                # for authenticating clients to access BRM WebServices
                idp:
                   # Chosen Identity Provider. Valid values: "OAM", "OAM11g", "IDCS"
                   vendor: OAM #Allowed values OAM/OAM11g/IDCS
                   # Base URL of the IdP server. For example, https://host:port
                   url:
                   # Name of the Identity Domain. Mandatory if vendor = OAM
                   identityDomain:
                   # base64 encoded Id of the client with access to IdP's validate token API. Mandatory if vendor = IDCS
                   clientId:
                   # base64 encoded Secret for client  to access IdP's validate token API
                   clientSecret:
                resources: {}

            tomcat:
                isEnabled: false
                replicaCount: 1
                imageName: brm_wsm_tomcat
                imageTag: 15.1.0.0.0
                port: 8080
                nodePort: 30080
                log_enabled: true
                minPoolSize: 1
                maxPoolSize: 8
                poolTimeout: 30000
                basicAuth: false
                walletPassword: QzFnMmIzdTQ=
                extBasicConfigCM:
                service:
                    type: ClusterIP
                resources: {}



    brm_sdk:
        isEnabled: false
        extCustomScriptsCM:
        deployment:
            imageName: brm_sdk
            imageTag: 15.1.0.0.0
        volume:
            storage: 50Mi
            createOption: {}
        resources: {}

# This section is for forwarding the logs to a log management system
# Applicable only for services running forwarder app as sidecar
logging:
    isEnabled: true
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
    isEnabled: true
    # log directory for webhook application
    logPath:
    # log level, Available options are CRITICAL, ERROR, INFO, DEBUG, WARNING and NOTSET
    logLevel: INFO
    extScriptsCM:
    deployment:
        # webhook application image name
        imageName: webhook
        # webhook application image tag
        imageTag: 15.1.0.0.0
        # image pull policy
        imagePullPolicy: IfNotPresent
        # resouce configuration for webhook application container
        resources: {}
    scripts:
        # scripts mount path
        mountPath: /u01/script
    # weblogic operator details
    wop:
        # namespace of weblogic operator
        namespace:
        # service account of weblogic operator
        sa: default
        # internal operator certficate present in operator configmap
        internalOperatorCert:
    # extra alert details in json format
    jsonConfig:

ocpdc:

# Setting true to will deploy PDC, setting false will undeploy/do not deploy PDC
     isEnabled: true
     # Setting true will clean OLD Domain and OLD Log/Out files
     isClean: true
     # Mandatory: Linux Language
     lang: "en_US.UTF-8"
     # Mandatory: Linux Time-Zone
     tz: "UTC"
     volume:
        # PVC for domain filesystem
        # when using hostpath make sure to configure same nodeSelector for pdc-doma-job and pdc-admin-server
        # During upgrade, migrating from static PV to dynamic PV is not allowed. In order to achieve this, redeploy PDC.
        domain:
          createOption: {}
        # Add sub template to create a static PV for this PVC.
        # Value for this key must adhere to Persistent Volume Spec. For example
        #  createOption:
        #    hostPath:
        #        path: <path-on-node>
        #        type: 'Directory'
     # Mandatory: Please provide the storage size for pdc-pv-pvc
     storageSize: "10Gi"
     #PDC Pod-level security attributes and common container settings
     #Default configuration is present on oc-cn-op-job-chart/pdc/securityContext/securityContext.yaml
     enableSecurityContext: "true"
     # Deployment keys
     deployment:
        fmw:
        #FMW image should be of 14.1.2.0 with OL9-JDK21
          imageRepository: "fra.ocir.io/fry4fxlvxkjt/communications_monetization/"
          imageName: "fmw-infrastructure"
          imageTag: ":14.1.2.0-jdk21-ol9"
        imageName: "pdc"
       # For non-empty tag, ":" MUST be perpended
        imageTag: ":15.1.0.0.0"
        imagePullPolicy: IfNotPresent
     # Define rules to schedule PDC JOB POD on particular node by using nodeSelector or affinity.
     nodeSelector:
       env: cts
     affinity: {}
     # Weblogic Operator
     wop:
        # Mandatory: The name of this WebLogic Server domain
        domainUID:  "pdc-domain"
        # Mandatory: Whether to include the server out file into the pod's stdout
        includeServerOutInPodLog: "true"
        # Below defaults are as recommended in Doc ID 1953515.1 and all are mandatory.
        jtaTimeoutSeconds: 10000
        jtaAbandonTimeoutSeconds: 10000
        stuckThreadMaxTime: 20000
        idlePeriodsUntilTimeout: 40
        setDataSourceXaTxnTimeout: true
        dataSourceXaTxnTimeout: 0
        pdcAppSesTimeOut: 36000
        pdcAppSesInvInterTimeOut: 3000
        # Weblogic Max Message Size, double quote the value.
        maxMessageSize: "10000000"
        # New users to be added in PDC domain
        # Available PDC groups: PricingAnalyst, PricingDesignAdmin, PricingReviewer
        # Each element takes "name", "description", "password" (base64 encoded) and group that is part of, like:
        # -   name:
        #     description:
        #     password:
        #     group:
        users: []

     # Setting resource requests and limits for PDC Domain Job
     resources:
        requests:
           cpu: "50m"
           memory: "256Mi"
        limits:
           cpu: "2000m"
           memory: "4Gi"
     # Environment/Configuration keys of PDC
     configEnv:
        # Mandatory: Set "yes" to expose SSL/https Port, "no" to expose http Port, "all" to expose both https/http ports.
        exposePorts: "all"
        # Mandatory: PDC t3ChannelPort is mandatory for ECE enabled system, in-case ECE deployed with different namespace.
        # Provide any available K8S port, node port range for Kubernetes is 30000 - 32767
        t3ChannelPort: 30799
        # PDC t3AddressAddress is optional, else provide master node IP or Load balancer IP.
        t3ChannelAddress:
        # Mandatory: PDC t3sChannelPort (T3 Channel through SSL) is mandatory for ECE enabled system
        # In-case ECE deployed with different namespace.
        # Provide any available K8S port, node port range for Kubernetes is 30000 - 32767
        t3sChannelPort: 30800
        # PDC t3sAddressAddress is optional,else provide master node IP or Load balancer IP.
        t3sChannelAddress:
        # Custom memory arguments for WebLogic AdminServer
        USER_MEM_ARGS: "-XX:+UseContainerSupport -Djava.security.egd=file:/dev/./urandom -XX:InitialRAMPercentage=25.0 -XX:MaxRAMPercentage=50.0 -XX:CompileThreshold=8000"
        # Custom java options for WebLogic AdminServer
        USER_JAVA_OPTIONS:
        #Create file java.security in pdc/java_security with ciphers needs to be disabled and provide file name, default empty
        javaSecurityFileName:
        # Provide comma seperated TLS versions. Supported values TLSv1.2,TLSv1.3
        tlsVersions:
        # Mandatory: Pricing Server Log Level. Applicable for trace log as well
        pdcAppLogLevel: "WARNING"
        # Mandatory: Pricing Server Log Size Limit. Applicable for trace log as well
        pdcAppLogFileSize: 500000
        # Mandatory: Pricing Server Log Count. Applicable for trace log as well
        pdcAppLogFileCount: 50
        # Mandatory -RCU Connection String, Format: DBHostName:DBPort/DBService
        # If ATP-S DB, provide TP Service.
        # Mandatory -RCU Connection String, Format: DBHostName:DBPort/DBService
        rcuJdbcURL: ${DBHOST}:1521/${DBSERVICE}
        # PDC Domain RCU Schema prefix, If prefix is XYZ then XYZ_STB will be created.
        rcuPrefix: rcupdcpoc
        # Mandatory: PDC Domain RCU drop and reccreate if already present
        rcuRecreate: true
        # Custom Weblogic Python file execution, true or false, true will execute the files from below mentioned location
        # Please place the python files in <oc-cn-op-job-chart>/pdc/customWLSPython
        # Set permission as chown <runAsUser>:0 and chmod 777 (Mandatory field), default runAsUser is 1000
        isCustomWLSPython: false
        # Copy OPSS Wallet from pdc-app-pvc/stores/opss_wallet/ewallet.p12 to <job-chart>/pdc/opss_wallet
        # then set addOPSSWallet to true else false (Mandatory field)
        # Note on 1st job chart run or new RCU prefix, ewallet.p12 will not be available in pdc-app-pvc/stores/opss_wallet
        addOPSSWallet: false
        # Name of the custom OPSS wallet secret
        extOPSSWallet: ""
        # Mandatory: Set true for RDS database to honor Oracle-Managed Files (OMF) format
        honorOMF: false
        # Mandatory: Domain SSL Key Store type.
        keyStoreType: "JKS"
        # Mandatory: PDC Domain SSL Key Store Alias name
        keyStoreAlias: "WeblogicPDCTestAlias"
        # Mandatory: PDC Domain SSL Key Store Identity Filename
        # Refer: https://docs.oracle.com/javase/8/docs/technotes/tools/unix/keytool.html
        # Please place the certificate file in pdc/pdc_keystore
        keyStoreIdentityFileName: "defaultserver.jks"
        # Mandatory: PDC Domain SSL  Key Trust Store Trust Filename
        keyStoreTrustFileName: "defaultclient.jks"
        # Name of the custom PDC Keystore secret
        extPDCKeystoreSecret: ""
        # Mandatory: Set to "true" to configure and use SAML 2.0, SSO service
        # copy OAM/IDCS metadata.xml to <oc-cn-op-job-chart>/pdc/idp/metadata.xml
        # Set permission as chown <runAsUser>:0 and chmod 777, default runAsUser is 1000
        isSSOEnabled: false
        # Name of the configmap containing IDP metadata file
        extMetadataCM:
        # Mandatory: Name of SAML Asserter
        samlAsserterName: "pdcSAML2IdentityAsserter"
        # Base URL that is used to construct endpoint URLs, Load Balancer host and port at which the server is visible externally.
        # Must be appended with "/saml2". Example: https://LB_HOST:LB_PORT/saml2 (Mandatory if isSSOEnabled set true)
        ssoPublishedSiteURL:
        # URL to which unsolicited authentication responses are sent if they do not contain an
        # accompanying target URL (Mandatory if isSSOEnabled set true)
        ssoDefaultURL:
        # URL where user will be redirected after logout from the application (Mandatory if isSSOEnabled set true)
        ssoLogoutURL:         # PDC and Cross Reference DB Host-name.
        dbHostName: "${DBHOST}"
        # PDC and Cross Reference DB Port
        dbPort: 1521
        # PDC and Cross Reference DB Service.
        dbService: "${DBSERVICE}"
        # PDC and Cross Reference DB SYS/System/Sys DBA User.
        dbSysDBAUser: "SYS"
        # PDC and Cross Reference DB SYS/System/Sys DBA User Role
        dbSysDBARole: "SYSDBA"
        # Mandatory: Set SSL Mode of PDC and Cross Reference DB, Legal values NO, ONE_WAY, TWO_WAY
        dbSSLMode: "NO"
        # Mandatory: Specify the DB SSL wallet type for PDC/Cross Reference: pkcs12 or sso
        dbWalletType: "SSO"
        # Name of the custom SSL secret for PDC DB
        extPDCDBSSLWalletSecret: ""
        # Mandatory: Cross Reference DB Schema PDC Table Space.
        crossRefSchemaPDCTableSpace: "USERS"
        # Mandatory: Cross Reference DB Schema PDC TEMP Table Space.
        crossRefSchemaTempTableSpace: "TEMP"
        # Mandatory: Cross Reference DB Schema User-name.
        crossRefSchemaUserName: "PDCXREF"
        # Mandatory: DC Application Schema PDC Table Space.
        pdcSchemaPDCTableSpace: "USERS"
        # Mandatory: PDC Application Schema TEMP Table.
        pdcSchemaTempTableSpace: "TEMP"
        # Mandatory: PDC Application Schema User-name.
        pdcSchemaUserName: "PDC"
        # Optional: RCU Wallet Schema User-name.
        rcuWalletSchemaUserName: "PDCRCUWALLET"
        # Mandatory: PDC Application Admin User-name, it is not recommended to use weblogic.
        pdcAdminUser: "cnepdcadminuser"
        # Mandatory: Set true to enable ECE - Elastic Charging Engine
        # Set false to enable RRE/BRE -- Real-time and Batch Rating Engine.
        supportECE: true
        # Optional: Set to true incase of ZDU upgrade, default false
        deployAndUpgradeSite2: false
        # Mandatory: Set true to upgrade from previous version to 15PS or while deploying 15IP
        upgrade: false


     # PDC Secret Password keys of PDC
     secretValue:
        # Domain adminUser password
        adminPassword: REJhZG1pbl8xMjMj
        # PDC Domain RCU Schema Password
        rcuSchemaPassword: REJhZG1pbl8xMjMj
        # Mandatory: PDC Domain SSL Identity Key Password
        # Default password 'UERDU1NMUGFzczEyMyM=' which is 'PDCSSLPass123#'
        keyStoreIdentityKeyPass: UERDU1NMUGFzczEyMyM=
        # Mandatory: PDC Domain SSL Identity Key Store Password
        # Default password 'UERDU1NMUGFzczEyMyM=' which is 'PDCSSLPass123#'
        keyStoreIdentityStorePass: UERDU1NMUGFzczEyMyM=
        # Mandatory: PDC Domain SSL Custom Trust Store Password
        # Default password 'UERDU1NMUGFzczEyMyM=' which is 'PDCSSLPass123#'
        keyStoreTrustStorePass: UERDU1NMUGFzczEyMyM=
        # PDC and Cross Reference Schema SYS/System User Password
        dbPassword: ${DBPASS}
        # PDC Application DB Schema Password
        pdcSchemaPassword: ${PINPASS}
        # PDC Cross Reference Schema Password
        crossRefSchemaPassword: ${PINPASS}
        # Mandatory: PDC RCU OPSS Wallet Schema Password
        # Default password 'UERDI1JDVVdhbGxldDEyMyM=' which is 'PDC#RCUWallet123#'
        rcuWalletSchemaPassword: REJhZG1pbl8xMjMj
        # Password of the DB SSL wallet. Required if walletType = pkcs12 Y2didTEyMzQ=
        dbWalletPassword: REJhZG1pbl8xMjMj
        # PDC Application Wallet and PDC BRM Integration Wallet password
        walletPassword: REJhZG1pbl8xMjMj
        # PDC Application AdminUser Password
        pdcAdminUserPassword: REJhZG1pbl8xMjMj

     service:
        name: "pdc-service"
        #By default "ClusterIP" service 'pdc-domain-adminserver' is deployed when PDC is deployed using oc-cn-helm-chart
        type: "ClusterIP"

ocboc:

    # Values used for Business Opearations Center application and its domain
    boc:
        # A boolean value to add (true) or remove (false) Billing Care and
        # all its associated resources
        isEnabled: true
        deployment:
            app:
                # Name of the boc image
                imageName: boc
                # Tag associated with image, generally, patch-set number
                # For non-empty tag, ":" MUST be prepended
                imageTag: :15.1.0.0.0
                # Image pull policy. One of Always, Never, IfNotPresent
                imagePullPolicy: IfNotPresent
            fmw:
                # Repository from where FMW Infrastructure image must be pulled
                imageRepository: fra.ocir.io/fry4fxlvxkjt/communications_monetization/
                # Name of the FMW Infrastructure image
                imageName: fmw-infrastructure
                # Tag associated with image, generally, patch-set number
                # For non-empty tag, ":" MUST be prepended
                imageTag: :14.1.2.0-jdk21-ol9
                # Image pull policy. One of Always, Never, IfNotPresent
                imagePullPolicy: IfNotPresent

        configEnv:
            # Container's port for access to Managed Server
            managedHttpPort: 8001
            # Container's port for access to WebLogic Domain over HTTP
            httpPort: 7011
            # Mode to use when starting the server. One of dev, prod
            serverStartMode: prod
            # User who will be granted Administrator rights to WebLogic Domain
            adminUser: weblogic
            # Host name or IP Address of Database Server
            dbHost: ${DBHOST}
            # Port number of Database Server
            dbPort: 1521
            # Service Name which identifies DB
            dbServiceName: ${DBSERVICE}
            # Specify the SSLMode : "NO", "ONE_WAY"
            dbSSLMode: "NO"
            # Specify the DB SSL wallet type: SSO
            dbWalletType:
            # Name of the secret containing SSL DB wallet
            extDBSSLWalletSecret:
            rcuSysDBAUser: SYS
            # Role of database administrator user
            rcuDBARole: SYSDBA
            # Prefix for schemas of OPSS
            rcuPrefix: BOC11
            # Drops existing OPSS schema already exists if true. One of true, false
            rcuRecreate: true
            # Additional arguments to create rcu
            rcuArgs: " "
            # Specify the name of an existing tablespace in your database.
            # If left empty, new tablespaces will be created with names starting with 'rcuPrefix'.
            rcuTablespace: " "
            # Specify the name of an existing temporary tablespace in your database.
            # If left empty, new tablespaces will be created with names starting with 'rcuPrefix'.
            rcuTempTablespace: " "
            # Create an OPSS or non-OPSS domain. One of true, false
            # Production setup must use OPSS (true) only
            isOPSS: true
            # Name of the configmap containing Policy file
            extAccessPolicyCM:
            # Skip creation of OracleUnifiedDirectoryAuthenticator. One of true, false
            isLDAPEnabled: false
            # Distinguished Name to connect to the LDAP server
            ldapAdmin: cn=Directory Manager
            # Host name or IP address of the LDAP server
            ldapHost: __LDAP_HOST__
            # Port number on which the LDAP server is listening
            ldapPort: 389
            # Base DN of the tree in LDAP directory that contains groups
            # Example: cn=Groups,dc=example,dc=com
            ldapGroupBase: __GROUP_BASE__
            # Base DN of the tree in LDAP directory that contains users
            # Example: cn=Users,dc=example,dc=com
            ldapUserBase: __USER_BASE__
            # Name of Authentication provider
            ldapProviderName: OUDAuthenticator
            #The user name of your Business Operations Center database administrator.
            bocSchemaUserName: bocdb
            #The default tablespace for the Business Operations Center database administrator.
            bocSchemaBocTablespace: boc_default_tbls
            #The temp tablespace for the database Business Operations Center administrator.
            bocSchemaTempTablespace: boc_temp_tbls
            #URL of the Oracle Communications Billing Care instance configured for use with your BRM Server if installed. Leave blank if Billing Care is not installed in your environment.
            billingCareUrl:
           #Redirect URL where Business Operations Center sends a user after logout and session termination.
            logoutUrl: login.html
            #Number of session idle seconds before Business Operations Center displays a timeout warning to a user (default value is 90 seconds).
            timeoutWaringDuration: 90
            pageSize: 25
            refreshInterval: "28800000"
            connectionTimeout: 16000
            #To create datasouce to connect to BOC DB.
            # DB Connection URL, valid formats:
            # SSL enabled DB: (DESCRIPTION=(ADDRESS=(PROTOCOL=tcps)(HOST=__DB_HOST__)(PORT=__DB_SSL_PORT__))(CONNECT_DATA=(SERVICE_NAME=__DB_SERVICE_NAME__)))
            # SSL disabled DB: __DB_HOST__:__DB_PORT__/__DB_SERVICE_NAME__
            dbURL:
            # To consider pin_virtual_time for Job execution
            enablePvt: true
            targetServer: cluster-1
            # Private Key Alias of the keystore
            keystoreAlias:
            # Name of the secret containing Identity and Trust keystore files
            extKeystoreSecret:
            # File type of SSL Identity and Trust store, either "PKCS12" or "JKS"
            keystoreType: PKCS12
            # File name of the Identity Keystore
            keystoreIdentityFileName:
            # File name of the Trust Keystore
            keystoreTrustFileName:
            # Comma separated values from lower to higher TLS version
            tlsVersions: ""
            # Set it to "true" if this service will use SSO and must be configured with SAML 2.0
            isSSOEnabled: false
            # Name of the configmap containing IDP metadata file
            extMetadataCM:
            # Name of SAML Asserter
            samlAsserterName: samlBOCAsserter
            # Base URL that is used to construct endpoint URLs, typically, Load Balancer host and port at which the server is visible externally.
            # Must be appended with "/saml2"
            # For example, https://LB_HOST:LB_PORT/saml2
            ssoPublishedSiteURL:
            # URL to which unsolicited authentication responses are sent if they do not contain an accompanying target URL
            ssoDefaultURL:
            # Update with any string different previous value to force restart of deployer
            reloadVersion: "1"
            # Set it to 'true' to wipe all previous state and do fresh setup of domain
            # When set to 'true', 'introspectVersion' in oc-cn-helm-chart must be changed after upgrade of this chart
            reset: "false"
        secretVal:
            # Password of the WebLogic Domain's administrative user (configEnv.adminUser)
            adminPassword:
            # Password of the Ldap Server Admin User (configEnv.ldapAdmin)
            ldapPassword:
            # Password of the Database Administrator (configEnv.rcuSysDBAUser)
            rcuSysDBAPassword:
            # Password of the OPSS schema (configEnv.rcuPrefix)
            rcuSchemaPassword:
            #The Business Operations Center database administrator password.
            bocSchemaPassword:
            # Password for truststore
            dbWalletPassword:
            # StorePass of Identity Keystore
            keystoreIdentityPassword:
            # KeyPass of Identity Keystore
            keystoreKeyPassword:
            # StorePass of Trust Keystore
            keystoreTrustPassword:
        wop:
            # Name of the domain
            # Used as prefix to tag related objects
            domainUID: boc-domain
            # Location within container where domain is created
            domainRootDir: /shared
            # Total number of managed servers forming the cluster
            totalManagedServers: 5
            # Number of managed servers to initially start for the domain
            initialServerCount: 2
            # NodePort where admin-server's http service will be accessible
            adminChannelPort: 30811
            # serverStartPolicy legal values are "NEVER", "IF_NEEDED", or "ADMIN_ONLY"
            # This determines which WebLogic Servers the Operator will start up when it discovers this Domain
            # - "NEVER" will not start any server in the domain
            # - "ADMIN_ONLY" will start up only the administration server (no managed servers will be started)
            # - "IF_NEEDED" will start all non-clustered servers, including the administration server and clustered servers up to the replica count
            serverStartPolicy: "IF_NEEDED"
        # Setting resource requests and limits for boc-domain-deployer pod
        resources:
            requests:
                cpu: "50m"
                memory: "512Mi"
            limits:
                cpu: "2000m"
                memory: "2Gi"
        volume:
            # PVC for domain filesystem
            domain:
                storage: "1Gi"
                # Add sub template to create a static PV for this PVC.
                # Value for this key must adhere to Persistent Volume Spec. For example,
                # createOption:
                #    hostPath:
                #        path: <path-on-node>
                #        type: 'Directory'
                createOption: {}
        # Add users and groups to domain's DefaultAuthenticator (local)
        wlsUserGroups:
            # New groups to be added locally to this domain
            # Each element for this takes "name" and "description", like:
            # -   name:
            #     description:
            groups:
            # New users to be added locally to this domain
            # Each element for this takes "name", "description", "password" (base64 encoded) and list of "groups" that he is part of, like:
            # -   name:
            #     description:
            #     password:
            #     groups:
            #     - "Regular CSR"
            users:
            - name: "bocuser"
              description: "Regular CSR"
              password: "REJhZG1pbl8xMjMj"
              groups:
              - "Regular CSR"
        extensions:
            # Name of configmap containing scripts to execute additional steps to configure domain and/or application
            scriptsConfigName: ""
        # Define rules for scheduling WebLogic Server pods on particular nodes
        # either by using nodeSelector or affinity
        pod:
         #addOnPodSpec: {}
         #Add details which will be injected to pod spec
         addOnPodSpec:
             securityContext:
                runAsUser: 1000
                runAsGroup: 3000
                fsGroup: 2000
                fsGroupChangePolicy: "OnRootMismatch"
ocbc:

    # Values used for Billing Care application and its domain
    bc:
        # A boolean value to add (true) or remove (false) Billing Care and
        # all its associated resources
        isEnabled: true
        deployment:
            app:
                imageName: billingcare
                # Tag associated with image, generally, patch-set number
                # For non-empty tag, ":" MUST be prepended
                imageTag: :15.1.0.0.0
                # Image pull policy. One of Always, Never, IfNotPresent
                imagePullPolicy: IfNotPresent
            fmw:
                # Repository from where FMW Infrastructure image must be pulled
                imageRepository: fra.ocir.io/fry4fxlvxkjt/communications_monetization/
                # Name of the FMW Infrastructure image
                imageName: fmw-infrastructure
                # Tag associated with image, generally, patch-set number
                # For non-empty tag, ":" MUST be prepended
                imageTag: :14.1.2.0-jdk21-ol9
                # Image pull policy. One of Always, Never, IfNotPresent
                imagePullPolicy: IfNotPresent
            sdk:
                # Name of the billingcare sdk image
                imageName:
                # Tag associated with image, generally, patch-set number
                # For non-empty tag, ":" MUST be prepended
                imageTag:
                # Image pull policy. One of Always, Never, IfNotPresent
                imagePullPolicy: IfNotPresent
        sdk:
            # A boolean value to additionally deploy your customizations to
            # override application behavior
            isEnabled: false
            # Name of SDK to appear in deployment list
            deployName: BillingCareCustomizations
        configEnv:
            # Container's port for access to Managed Server
            managedHttpPort: 8001
            # Container's port for access to WebLogic Domain over HTTP
            httpPort: 7011
            # Mode to use when starting the server. One of dev, prod
            serverStartMode: prod
            # User who will be granted Administrator rights to WebLogic Domain
            adminUser: weblogic
            # Specify the SSLMode : "NO", "ONE_WAY"
            dbSSLMode:
            # Specify the DB SSL wallet type: SSO
            dbWalletType:
            # Name of the secret containing SSL DB wallet
            extDBSSLWalletSecret: ""
            # Database connection details where OPSS schema will be created
            # DB Connection URL, valid formats:
            # SSL enabled DB: (DESCRIPTION=(ADDRESS=(PROTOCOL=tcps)(HOST=__DB_HOST__)(PORT=__DB_SSL_PORT__))(CONNECT_DATA=(SERVICE_NAME=__DB_SERVICE_NAME__)))
            # SSL disabled DB: __DB_HOST__:__DB_PORT__/__DB_SERVICE_NAME__
            rcuJdbcURL:
            # Database administrator user name
            rcuSysDBAUser:
            # Role of database administrator user
            rcuDBARole:
            # Prefix for schemas of OPSS
            rcuPrefix: BC01
            # Drops existing OPSS schema already exists if true. One of true, false
            rcuRecreate: true
            # Additional arguments to create rcu
            rcuArgs: " "
            # Specify the name of an existing tablespace in your database.
            # If left empty, new tablespaces will be created with names starting with 'rcuPrefix'.
            rcuTablespace: " "
            # Specify the name of an existing temporary tablespace in your database.
            # If left empty, new tablespaces will be created with names starting with 'rcuPrefix'.
            rcuTempTablespace: " "
            # Create an OPSS or non-OPSS domain. One of true, false
            # Production setup must use OPSS (true) only
            isOPSS: false
            # Name of the configmap containing Policy file
            extAccessPolicyCM:
            # Skip creation of OracleUnifiedDirectoryAuthenticator. One of true, false
            isLDAPEnabled: false
            # Distinguished Name to connect to the LDAP server
            ldapAdmin: cn=Directory Manager
            # Host name or IP address of the LDAP server
            ldapHost: __LDAP_HOST__
            # Port number on which the LDAP server is listening
            ldapPort: 389
            # Base DN of the tree in LDAP directory that contains groups
            # Example: cn=Groups,dc=example,dc=com
            ldapGroupBase: __GROUP_BASE__
            # Base DN of the tree in LDAP directory that contains users
            # Example: cn=Users,dc=example,dc=com
            ldapUserBase: __USER_BASE__
            # Name of Authentication Provider
            ldapProviderName: OUDAuthenticator
            # Server in WebLogic domain where application must be deployed
            targetServer: cluster-1
            # Private Key Alias of the keystore
            keystoreAlias:
            # Name of the secret containing Identity and Trust keystore files
            extKeystoreSecret:
            # File type of SSL Identity and Trust store, either "PKCS12" or "JKS"
            keystoreType: PKCS12
            # File name of the Identity Keystore
            keystoreIdentityFileName:
            # File name of the Trust Keystore
            keystoreTrustFileName:
            # Comma separated values from lower to higher TLS version
            tlsVersions: ""
            # Set it to "true" if this service will use SSO and must be configured with SAML 2.0
            isSSOEnabled: false
            # Name of the configmap containing IDP metadata file
            extMetadataCM:
            # Name of SAML Asserter
            samlAsserterName: samlBCAsserter
            # Base URL that is used to construct endpoint URLs, typically, Load Balancer host and port at which the server is visible externally.
            # Must be appended with "/saml2"
            # For example, https://LB_HOST:LB_PORT/saml2
            ssoPublishedSiteURL:
            # URL to which unsolicited authentication responses are sent if they do not contain an accompanying target URL
            ssoDefaultURL:
            # Update with any string different previous value to force restart of deployer
            reloadVersion: "1"
            # Set it to 'true' to wipe all previous state and do fresh setup of domain
            # When set to 'true', 'introspectVersion' in oc-cn-helm-chart must be changed after upgrade of this chart
            reset: "false"
        secretVal:
            # Password of the WebLogic Domain's administrative user (configEnv.adminUser)
            adminPassword:
            # Password of the Ldap Server Admin User (configEnv.ldapAdmin)
            ldapPassword:
            # Password of the Database Administrator (configEnv.rcuSysDBAUser)
            rcuSysDBAPassword:
            # Password of the OPSS schema (configEnv.rcuPrefix)
            rcuSchemaPassword:
            # Password for truststore
            dbWalletPassword:
            # StorePass of Identity Keystore
            keystoreIdentityPassword:
            # KeyPass of Identity Keystore
            keystoreKeyPassword:
            # StorePass of Trust Keystore
            keystoreTrustPassword:
        wop:
            # Name of the domain
            # Used as prefix to tag related objects
            domainUID: billingcare-domain
            # Location within container where domain is created
            domainRootDir: /shared
            # Total number of managed servers forming the cluster
            totalManagedServers: 5
            # Number of managed servers to initially start for the domain
            initialServerCount: 2
            # NodePort where admin-server's http service will be accessible
            adminChannelPort: 30711
            # serverStartPolicy legal values are "NEVER", "IF_NEEDED", or "ADMIN_ONLY"
            # This determines which WebLogic Servers the Operator will start up when it discovers this Domain
            # - "NEVER" will not start any server in the domain
            # - "ADMIN_ONLY" will start up only the administration server (no managed servers will be started)
            # - "IF_NEEDED" will start all non-clustered servers, including the administration server and clustered servers up to the replica count
            serverStartPolicy: "IF_NEEDED"
        volume:
            # PVC for domain filesystem
            domain:
                storage: "1Gi"
                # Add sub template to create a static PV for this PVC.
                # Value for this key must adhere to Persistent Volume Spec. For example,
                # createOption:
                #    hostPath:
                #        path: <path-on-node>
                #        type: 'Directory'
                createOption: {}
            # PVC for batch payment files
            batchPayment:
                storage: "4Gi"
                # Add sub template to create a static PV for this PVC
                # Value for this key must adhere to Persistent Volume Spec
                createOption: {}
        # Add users and groups to domain's DefaultAuthenticator (local)
        wlsUserGroups:
            # New groups to be added locally to this domain
            # Each element for this takes "name" and "description", like:
            # -   name:
            #     description:
            groups:
            - name: "POC"
              description: "POC purpose"
            # New users to be added locally to this domain
            # Each element for this takes "name", "description", "password" (base64 encoded) and list of "groups" that he is part of, like:
            # -   name:
            #     description:
            #     password:
            #     groups:
            #     - "Regular CSR"
            users:
            - name: "bcuser"
              description: "POC Purpose"
              password: "REJhZG1pbl8xMjMj"
              groups:
              - "POC"
        extensions:
            # Name of configmap containing scripts to execute additional steps to configure domain and/or application
            scriptsConfigName: ""
        # Setting resource requests and limits for billingcare-domain-deployer pod
        resources:
            requests:
                cpu: "50m"
                memory: "512Mi"
            limits:
                cpu: "2000m"
                memory: "2Gi"
        # Define rules for scheduling WebLogic Server pods on particular nodes
        # either by using nodeSelector or affinity
        nodeSelector:
          env: cts
        affinity: {}
        pod:
         #addOnPodSpec: {}
         #Add details which will be injected to pod spec
         addOnPodSpec:
             securityContext:
                runAsUser: 1000
                runAsGroup: 3000
                fsGroup: 2000
                fsGroupChangePolicy: "OnRootMismatch"
    # Values used for Billing Care REST API and its domain
    bcws:
        # A boolean value to add (true) or remove (false) Billing Care REST API
        # and all its associated resources
        isEnabled: true
        deployment:
            app:
                imageName: bcws
                # Tag associated with image, generally, patch-set number
                # For non-empty tag, ":" MUST be prepended
                imageTag: :15.1.0.0.0
                # Image pull policy. One of Always, Never, IfNotPresent
                imagePullPolicy: IfNotPresent
            fmw:
                # Repository from where FMW Infrastructure image must be pulled
                imageRepository: fra.ocir.io/fry4fxlvxkjt/communications_monetization/
                # Name of the FMW Infrastructure image
                imageName: fmw-infrastructure
                # Tag associated with image, generally, patch-set number
                # For non-empty tag, ":" MUST be prepended
                imageTag: :14.1.2.0-jdk21-ol9
                # Image pull policy. One of Always, Never, IfNotPresent
                imagePullPolicy: IfNotPresent
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
            # Container's port for access to Managed Server
            managedHttpPort: 8001
            # Container's port for access to WebLogic Domain over HTTP
            httpPort: 7011
            # Mode to use when starting the server. One of dev, prod
            serverStartMode: prod
            # User who will be granted Administrator rights to WebLogic Domain
            adminUser: weblogic
            # Specify the SSLMode : "NO", "ONE_WAY"
            dbSSLMode:
            # Specify the DB SSL wallet type: SSO
            dbWalletType:
            # Name of the secret containing SSL DB wallet
            extDBSSLWalletSecret: ""
            # Database connection details where OPSS schema will be created
            # DB Connection URL, valid formats:
            # SSL enabled DB: (DESCRIPTION=(ADDRESS=(PROTOCOL=tcps)(HOST=__DB_HOST__)(PORT=__DB_SSL_PORT__))(CONNECT_DATA=(SERVICE_NAME=__DB_SERVICE_NAME__)))
            # SSL disabled DB: __DB_HOST__:__DB_PORT__/__DB_SERVICE_NAME__
            rcuJdbcURL:
            # Database administrator user name
            rcuSysDBAUser:
            # Role of database administrator user
            rcuDBARole:
            # Prefix for schemas of OPSS
            rcuPrefix: BCWS01
            # Drops existing OPSS schema already exists if true. One of true, false
            rcuRecreate: true
            # Additional arguments to create rcu
            rcuArgs: " "
            # Specify the name of an existing tablespace in your database.
            # If left empty, new tablespaces will be created with names starting with 'rcuPrefix'.
            rcuTablespace: " "
            # Specify the name of an existing temporary tablespace in your database.
            # If left empty, new tablespaces will be created with names starting with 'rcuPrefix'.
            rcuTempTablespace: " "
            # Create an OPSS or non-OPSS domain. One of true, false
            # Production setup must use OPSS (true) only
            isOPSS: false
            # Name of the configmap containing Policy file
            extAccessPolicyCM:
            # Skip creation of OracleUnifiedDirectoryAuthenticator. One of true, false
            isLDAPEnabled: false
            # Distinguished Name to connect to the LDAP server
            ldapAdmin: cn=Directory Manager
            # Host name or IP address of the LDAP server
            ldapHost: __LDAP_HOST__
            # Port number on which the LDAP server is listening
            ldapPort: 389
            # Base DN of the tree in LDAP directory that contains groups
            # Example: cn=Groups,dc=example,dc=com
            ldapGroupBase: __GROUP_BASE__
            # Base DN of the tree in LDAP directory that contains users
            # Example: cn=Users,dc=example,dc=com
            ldapUserBase: __USER_BASE__
            # Name of Authentication Provider
            ldapProviderName: OUDAuthenticator
            # Server in WebLogic domain where application must be deployed
            targetServer: cluster-1
            # Private Key Alias of the keystore
            keystoreAlias:
            # Name of the secret containing Identity and Trust keystore files
            extKeystoreSecret:
            # File type of SSL Identity and Trust store, either "PKCS12" or "JKS"
            keystoreType: PKCS12
            # File name of the Identity Keystore
            keystoreIdentityFileName:
            # File name of the Trust Keystore
            keystoreTrustFileName:
            # Comma separated values from lower to higher TLS version
            tlsVersions: ""
            # Update with any string different previous value to force restart of deployer
            reloadVersion: "1"
            # Set it to 'true' to wipe all previous state and do fresh setup of domain
            # When set to 'true', 'introspectVersion' in oc-cn-helm-chart must be changed after upgrade of this chart
            reset: "false"
        secretVal:
            # Password of the WebLogic Domain's administrative user (configEnv.adminUser)
            adminPassword:
            # Password of the Ldap Server Admin User (configEnv.ldapAdmin)
            ldapPassword:
            # Password of the Database Administrator (configEnv.rcuSysDBAUser)
            rcuSysDBAPassword:
            # Password of the OPSS schema (configEnv.rcuPrefix)
            rcuSchemaPassword:
            # Password for truststore
            dbWalletPassword:
            # StorePass of Identity Keystore
            keystoreIdentityPassword:
            # KeyPass of Identity Keystore
            keystoreKeyPassword:
            # StorePass of Trust Keystore
            keystoreTrustPassword:
        wop:
            # Name of the domain
            # Used as prefix to tag related objects
            domainUID: bcws-domain
            # Location within container where domain is created
            domainRootDir: /shared
            # Total number of managed servers forming the cluster
            totalManagedServers: 5
            # Number of managed servers to initially start for the domain
            initialServerCount: 2
            # NodePort where admin-server's http service will be accessible
            adminChannelPort: 30721
            # serverStartPolicy legal values are "NEVER", "IF_NEEDED", or "ADMIN_ONLY"
            # This determines which WebLogic Servers the Operator will start up when it discovers this Domain
            # - "NEVER" will not start any server in the domain
            # - "ADMIN_ONLY" will start up only the administration server (no managed servers will be started)
            # - "IF_NEEDED" will start all non-clustered servers, including the administration server and clustered servers up to the replica count
            serverStartPolicy: "IF_NEEDED"
        volume:
            # PVC for domain filesystem
            domain:
                storage: "1Gi"
                # Add sub template to create a static PV for this PVC.
                # Value for this key must adhere to Persistent Volume Spec. For example,
                # createOption:
                #    hostPath:
                #        path: <path-on-node>
                #        type: 'Directory'
                createOption: {}
            # PVC for batch payment files
            batchPayment:
                storage: "4Gi"
                # Add sub template to create a static PV for this PVC
                # Value for this key must adhere to Persistent Volume Spec
                createOption: {}
        # Add users and groups to domain's DefaultAuthenticator (local)
        wlsUserGroups:
            # New groups to be added locally to this domain
            # Each element for this takes "name" and "description", like:
            # -   name:
            #     description:
            groups:
            - name: "POC"
              description: "POC purpose"
            # New users to be added locally to this domain
            # Each element for this takes "name", "description", "password" (base64 encoded) and list of "groups" that he is part of, like:
            # -   name:
            #     description:
            #     password:
            #     groups:
            #     - "Regular CSR"
            users:
            - name: "bcrestuser"
              description: "POC Purpose"
              password: "REJhZG1pbl8xMjMj"
              groups:
              - "POC"
        extensions:
            # Name of configmap containing scripts to execute additional steps to configure domain and/or application
            scriptsConfigName: ""
        # Setting resource requests and limits for bcws-domain-deployer pod
        resources:
            requests:
                cpu: "50m"
                memory: "512Mi"
            limits:
                cpu: "2000m"
                memory: "2Gi"
        # Define rules for scheduling WebLogic Server pods on particular nodes
        # Define rules for scheduling WebLogic Server pods on particular nodes
        # either by using nodeSelector or affinity
        nodeSelector:
          env: cts
        affinity: {}
        pod:
         addOnPodSpec: {}
         #Add details which will be injected to pod spec
         addOnPodSpec:
             securityContext:
                runAsUser: 1000
                runAsGroup: 3000
                fsGroup: 2000
                fsGroupChangePolicy: "OnRootMismatch"

ocpcc:

    # Values used for PCC application and its domain
    pcc:
        # A boolean value to add (true) or remove (false) PCC and
        # all its associated resources
        isEnabled: false
