enableSecurityContext: "true"
securityContext:
   runAsUser: 1000
   fsGroup: 1000
createWalletsAsSecrets: "true"
secretEnv:
   extECESecret:
   name: secret-env
   uniPass: "Q1RTdHJhaW5lcl8xMjMj"
   walletPassword: "Q1RTdHJhaW5lcl8xMjMj"
   JMSQUEUEPASSWORD: "Q1RTdHJhaW5lcl8xMjMj"
   RADIUSSHAREDSECRET: "Q1RTdHJhaW5lcl8xMjMj"
   NOTIFYEVENTKEYPASS: "Q1RTdHJhaW5lcl8xMjMj"
   BRMGATEWAYPASSWORD: "Q1RTdHJhaW5lcl8xMjMj"
   PDCPASSWORD: "Q1RTdHJhaW5lcl8xMjMj"
   PDCKEYSTOREPASSWORD: "Q1RTdHJhaW5lcl8xMjMj"
   PERSISTENCEDATABASEPASSWORD:
     - schema: 1
       PASSWORD: "${PINPASS}"
   PERSISTENCEDBAPASSWORD:
     - schema: 1
       PASSWORD: "${DBPASS}"
   PERSISTENCEDATABASEKEYPASS:
     - schema: 1
       PASSWORD: "${PINPASS}"
   ECEHTTPGATEWAYSERVERSSLKEYSTOREPASSWORD:
   ECEHTTPGATEWAYIDENTITYKEYSTOREPASSWORD:
   ECEHTTPGATEWAYTRUSTSTOREPASSWORD:
   ECEKAFKATRUSTSTOREPASSWORD: "QWRtQDEyMw=="
   ECEOAUTH2SYMMETRICKEY:
   BRM_SERVER_WALLET_PASSWD: "Q1RTdHJhaW5lcl8xMjMj"
   BRM_ROOT_WALLET_PASSWD: "Q1RTdHJhaW5lcl8xMjMj"
   BRMDATABASEPASSWORD:
      - schema: 1
        PASSWORD: "UElOIzEwMF91c2Vy"
   BRMDATABASEKEYPASS:
      - schema: 1
        PASSWORD: "UElOIzEwMF91c2Vy"


customerUpdater:
   resources: {}
   customerUpdaterList:
      - schemaNumber: "1"
        coherenceMemberName: "customerupdater1"
        replicas: 1
        jmxEnabled: true
        coherencePort: ""
        jvmGCOpts: "-XX:+UnlockExperimentalVMOptions -XX:+UseG1GC -XX:MaxGCPauseMillis=50 -XX:GCPauseIntervalMillis=200"
        jvmJMXOpts: "-Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false -Dcom.sun.management.jmxremote.local.only=false "
        jvmCoherenceOpts: "-Dpof.config=charging-pof-config.xml -Dcoherence.override=charging-coherence-override-dev.xml  -Dcoherence.security=false -Dsecure.access.name=admin"
        jvmOpts: "-Dece.metrics.http.service.enabled=true -DcontinueCustomerLoaderOnError=true -Dfile.encoding=UTF-8 --add-opens=java.base/java.time=ALL-UNNAMED --add-opens=java.base/java.util=ALL-UNNAMED"
        jmxport: ""
        restartCount: "0"
        oracleQueueConnectionConfiguration:
           name: "customerupdater1"
           gatewayName: "customerupdater1"
           hostName: "${DBHOST}"
           port: "1521"
           sid: "pindb"
           userName: "pin"
           jdbcUrl: "jdbc:oracle:thin:@${DBHOST}:1521/${DBSERVICE}"
           queueName: "IFW_SYNC_QUEUE"
           suspenseQueueName: "ECE_SUSPENSE_QUEUE"
           ackQueueName: "ECE_ACK_QUEUE"
           amtAckQueueName: "ECE_AMT_ACK_QUEUE"
           dbSSLEnabled: "false"
           tlsVersion: "1.3"
           dbSSLType: "oneway"
           sslServerCertDN: "DC=local,DC=oracle,CN=pindb"
           trustStoreLocation: "/home/charging/ext/ece_ssl_db_wallet/schema1/cwallet.sso"
           trustStoreType: "SSO"
           batchSize: "1"
           dbTimeout: "900"
           retryCount: "10"
           retryInterval: "60"
           walletLocation: "/home/charging/wallet/ecewallet/"
           oraFilesLocation: "/home/charging/ext/ora_files/brm/"
           extBRMDBSSLWalletSecret:

charging:
   # Identifier label for charging component
   labels: "ece"
   jmxport: "30421"
   coherencePort: ""
   autoGenerateAppConfig: "true"
   metrics:
      port: "19612"
   ecs:
     jmxport: "30422"
     replicas: 3
     maxreplicas: 3
     managementEnabledReplicas: 1
     coherenceMemberName: "ecs"
     jmxEnabled: true
     coherencePort:
     enableCoherenceReporting: "false"
   # clusterName determines site where ref pod is running.
   clusterName: "BRM"
   isFederation: "false"
   activeCluster: "true"
   secondaryCluster: "false"
   eceWalletLocation: "/home/charging/wallet/ecewallet/"
   brmWalletServerLocation: "/home/charging/wallet/brmwallet/server/cwallet.sso"
   brmWalletClientLocation: "/home/charging/wallet/brmwallet/client/cwallet.sso"
   brmWalletLocation: "/home/charging/wallet/brmwallet"
   customSSLWallet: false

   connectionConfigurations:
         OraclePersistenceConnectionConfigurations:
            - clusterName: "BRM"
              schemaNumber: "1"
              name: "oraclePersistence1"
              dbSysDBAUser: "sys"
              dbSysDBARole: "sysdba"
              userName: "ece"
              hostName: "${DBHOST}"
              port: "1521"
              sid: ""
              service: "${DBSERVICE}"
              tablespace: "ECE_DATA"
              temptablespace: "ECE_TEMP"
              cdrstoretablespace: "ECECDR_DATA"
              cdrstoreindexspace: "ECECDR_IND"
              jdbcUrl: "jdbc:oracle:thin:@${DBHOST}:1521/${DBSERVICE}"
              retryCount: "3"
              retryInterval: "1"
              maxStmtCacheSize: "100"
              connectionWaitTimeout: "300"
              timeoutConnectionCheckInterval: "300"
              inactiveConnectionTimeout: "300"
              databaseConnectionTimeout: "600"
              persistenceInitialPoolSize: "4"
              persistenceMinPoolSize: "4"
              persistenceMaxPoolSize: "12"
              reloadInitialPoolSize: "0"
              reloadMinPoolSize: "0"
              reloadMaxPoolSize: "20"
              ratedEventInitialPoolSize: "0"
              ratedEventMinPoolSize: "1"
              ratedEventMaxPoolSize: "1"
              ratedEventFormatterInitialPoolSize: "6"
              ratedEventFormatterMinPoolSize: "6"
              ratedEventFormatterMaxPoolSize: "6"
              ratedEventTablePartitionByMinute: "5"
              ratedEventTableStorageInitial: "104857600"
              ratedEventTableStorageNext: "104857600"
              ratedEventTableSubpartitions: "32"
              dbSSLEnabled: "false"
              tlsVersion: "1.3"
              dbSSLType: "oneway"
              sslServerCertDN: "DC=local,DC=oracle,CN=pindb"
              trustStoreLocation: "/home/charging/ext/ece_ssl_db_wallet/schema1/cwallet.sso"
              trustStoreType: "SSO"
              walletLocation: "/home/charging/wallet/ecewallet/"
              cdrStorePartitionCount: "32"
              queryTimeout: "5"
              oraFilesLocation: "/home/charging/ext/ora_files/ece/"
              extPersistenceDBSSLWalletSecret:


log4j2:
   logger:
      # Set to "ERROR" means focusing on logging error-level events and higher.
      # Set to "INFO" means enabling logging of informational messages and higher levels of severity.
      # Set to "DEBUG" means enabling the most detailed logging, including debug-level messages.
      # Set to "WARN" means Logging warning messages and higher levels of severity.
      appconfiguration: "DEBUG"
      balance: "DEBUG"
      brs: "DEBUG"
      brsDiagnostics: "DEBUG"
      diametergatewayCdrtrace: "OFF"
      ecsCdrtrace: "OFF"
      config: "DEBUG"
      customer: "DEBUG"
      dsl: "DEBUG"
      ecegatewayDiameterFramework: "DEBUG"
      ecegatewayDiameterGy: "DEBUG"
      ecegatewayDiameterLauncher: "DEBUG"
      ecegatewayDiameterSh: "DEBUG"
      ecegatewayDiameterSy: "DEBUG"
      diameterTekelec: "DEBUG"
      camiant: "DEBUG"
      camiantDiameterApps: "DEBUG"
      ecegatewayRadius: "DEBUG"
      ecegatewayHttpServer: "DEBUG"
      ecegatewayCdr: "DEBUG"
      cdrFormatter: "DEBUG"
      cdrFormatterPlugin: "DEBUG"
      extensions: "DEBUG"
      federationClient: "DEBUG"
      federationInterceptor: "DEBUG"
      identity: "DEBUG"
      brmgateway: "DEBUG"
      emgateway: "DEBUG"
      kafka: "DEBUG"
      messagesFramework: "DEBUG"
      messagesManagement: "DEBUG"
      messagesQuery: "DEBUG"
      messagesUpdate: "DEBUG"
      messagesUsage: "DEBUG"
      migrationConfig: "DEBUG"
      migrationCrossref: "DEBUG"
      customerLoader: "DEBUG"
      customerUpdater: "DEBUG"
      pricingLoader: "DEBUG"
      pricingUpdater: "DEBUG"
      notification: "DEBUG"
      requestenrichment: "DEBUG"
      orchestrationCommon: "DEBUG"
      orchestrationFramework: "DEBUG"
      orchestrationManagement: "DEBUG"
      orchestrationQuery: "DEBUG"
      orchestrationSubscription: "DEBUG"
      orchestrationUpdate: "DEBUG"
      orchestrationUsage: "DEBUG"
      orchestrationPolicy: "DEBUG"
      pdcspecgen: "DEBUG"
      pricing: "DEBUG"
      processorFramework: "DEBUG"
      processorManagement: "DEBUG"
      processorUpdate: "DEBUG"
      processorUsage: "DEBUG"
      product: "DEBUG"
      ratedeventDao: "DEBUG"
      ratedeventFormatter: "DEBUG"
      ratedeventFormatterPlugin: "DEBUG"
      ratedeventPurgeratedevent: "DEBUG"
      ratedeventService: "DEBUG"
      ratedeventtrace: "DEBUG"
      rating: "DEBUG"
      ratingCharge: "DEBUG"
      ratingAlteration: "DEBUG"
      ratingDistribution: "DEBUG"
      server: "DEBUG"
      session: "DEBUG"
      sharingagreement: "DEBUG"
      statemanager: "DEBUG"
      subscribertraceConfiguration: "DEBUG"
      subscribertraceLog: "DEBUG"
      monitorFramework: "DEBUG"
      monitorAgent: "DEBUG"
      monitorConfiguration: "DEBUG"
      monitorUtils: "DEBUG"
      monitorSummary: "DEBUG"
      monitorAlert: "DEBUG"
      cachepersistenceDao: "DEBUG"
      cachepersistenceReload: "DEBUG"
      cachepersistencePersist: "DEBUG"
      cachepersistenceData: "DEBUG"
      cachepersistenceUtil: "DEBUG"
      toolsLpr: "DEBUG"
      tools: "DEBUG"
      highavailability2: "DEBUG"
      transports: "DEBUG"
      util: "DEBUG"
      utilCacheMigration: "DEBUG"
      utilEvictingQueue: "DEBUG"
      Coherence: "DEBUG"
      springframework: "DEBUG"
      brmRatedeventmanager: "DEBUG"
      brmRatedeventmanagerDiagnostic: "DEBUG"

cdrgatewayService:
    port: 8084
diametergatewayService:
    port: 3868
    nodePort: 30423
    type: NodePort
radiusgatewayService:
    port: 1812
    nodePort: 30424
    type: NodePort
httpgatewayService:
    port: 8080
    type: NodePort
    nodePort: 30425
jmxservice:
    port: ""
    type: NodePort
monitoringagent:
    port: 8085
    nodeport: 30426
    type: NodePort

# storageClass: Specifies the StorageClass for dynamic volume provisioning, if needed.
storageClass:
   # Name of the StorageClass to use.
   name: brm-shared-storage
