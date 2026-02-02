# This is a YAML-formatted file.

# Repository server from where images must be pulled
# Value format: [host[:port]]
# For non-empty repository, "/" MUST be appended
imageRepository: "fra.ocir.io/fry4fxlvxkjt/communications_monetization/"
# Secrets required to pull images from the repository
imagePullSecrets: "brm-registry"
container:
   # The image to be used in the container
   image: "oc-cn-ece:wp2"
   # Image pull policy. One of Always, Never, IfNotPresent
   imagePullPolicy: IfNotPresent
volume:
   # Path to the charging settings configuration
   chargingSettingPath: "/home/charging/opt/ECE/oceceserver/config"
# Enables the security context for the container.
enableSecurityContext: "true"
# Security context configurations for the container
securityContext:
   # User ID under which the container process will run
   runAsUser: 1000
   # File system group ID under which the container process will run
   fsGroup: 1000
createWalletsAsSecrets: "true"
secretEnv:
   # Name of the external secret, if present
   extECESecret:
   # Name of the secret environment variable
   name: secret-env
   # Universal password to configure all of the below password
   uniPass: "REI1NXJtX3MxdCMx"
   # Password to wallet storing sensitive data for ECE connection
   walletPassword: "REI1NXJtX3MxdCMx"
   # Password for JMS Queue access
   JMSQUEUEPASSWORD: "REI1NXJtX3MxdCMx"
   # Shared secret for Radius authentication
   RADIUSSHAREDSECRET: "REI1NXJtX3MxdCMx"
   # Key passphrase for notification events
   NOTIFYEVENTKEYPASS: "REI1NXJtX3MxdCMx"
   # Password for BRM Gateway access
   BRMGATEWAYPASSWORD: "REI1NXJtX3MxdCMx"
   # Password for PDC access
   PDCPASSWORD: "UERDMTVybV9zMXQj"
   # Keystore password for PDC
   PDCKEYSTOREPASSWORD: "REI1NXJtX3MxdCMx"
   # Persisted database passwords for different schemas
   PERSISTENCEDATABASEPASSWORD:
     - schema: 1
       PASSWORD: "${PINPASS}"
   PERSISTENCEDBAPASSWORD:
     - schema: 1
       PASSWORD: "${DBPASS}"
   PERSISTENCEDATABASEKEYPASS:
     - schema: 1
       PASSWORD: "${PINPASS}"
   # Password for ECE HTTP Gateway server to access the SSL Keystore file
   ECEHTTPGATEWAYSERVERSSLKEYSTOREPASSWORD:
   # Password for ECE HTTP gateway identity keystore
   ECEHTTPGATEWAYIDENTITYKEYSTOREPASSWORD:
   # Password for ECE HTTP gateway truststore
   ECEHTTPGATEWAYTRUSTSTOREPASSWORD:
   # Stores the password for the truststore used by the ECE system to trust certificates from Kafka servers.
   ECEKAFKATRUSTSTOREPASSWORD:
  # Stores the symmetric key which is used for token validation when request comes through and oauth2Enabled=true.
   ECEOAUTH2SYMMETRICKEY:
   # BRM server wallet password
   BRM_SERVER_WALLET_PASSWD: "REI1NXJtX3MxdCMx"
   # BRM root wallet password
   BRM_ROOT_WALLET_PASSWD: "REI1NXJtX3MxdCMx"
   # BRM Database passwords for different schemas
   BRMDATABASEPASSWORD:
      - schema: 1
        PASSWORD: "REI1NXJtX3MxdCMx"
   BRMDATABASEKEYPASS:
      - schema: 1
        PASSWORD: "REI1NXJtX3MxdCMx"
sslconnectioncertificates:
   #enable ssl connection certificates generate, export, import
   SSLENABLED: "true"
   #mandatory format should be as below
   DNAME: "CN=$${HOSTNAME}, OU=Oracle Communication Application, O=Oracle Corporation, L=Redwood Shores, S=California, C=US"
   #validity units is in Days (for e.g 200 days)
   SSLKEYSTOREVALIDITY: 200000

# Job configuration for SDK, customer loader, JMS config, and charging configuration reloader
job:
   sdk:
      # Name of the sdk job
      name: "sdk"
      # Command to execute for the sdk job.
      command: ""
      # Flag to control whether the sdk job should be run. Set to "true" to enable.
      runjob: "false"
      #Resources for sdk job
      resources: {}
   customerloader:
      # Name of the customer loader job
      name: "customerloader"
      #To load the product cross-reference data, set -loadCrossRefData <customer_updater_name for required schema>
      command: "-incremental customerupdater1"
      # Flag to control whether the customer loader job should be run. Set to "true" to enable.
      runjob: "false"
      #Resources for customer loader job
      resources: {}
   jmsconfig:
      # Name of the JMS configuration job
      name: "jmsconfig"
      # Command to execute for the JMS configuration job
      command: ""
      # Flag to control whether the JMS configuration job should be run. Set to "true" to enable.
      runjob: "false"
      # Flag to control whether JMS server and module should be pre-created. Set to "true" to enable.
      preCreateJmsServerAndModule: "false"
      adminServerName: "Adminserver"
      #Resources for JMS configuration job
      resources: {}
   chargingConfigurationReloader:
     # Name of the charging configuration reloader job
     name: "charging-configuration-reloader"
     # AppConfig reload configuration
     reloadAppConfig:
       runjob: "false"
       #Specify mBean name to be reloaded in AppConfig in below command parameter.
       # for example, command: "charging.server"
       command: ""
     # Logging reload configuration
     reloadLogging:
       runjob: "false"
       #Specify Operation name, Logger or FunctionalDomain and LogLevel in below command parameter.
       # for example, command: "setGridLogLevel oracle.communication.brm.charging.appconfiguration ERROR"
       #Supported Operations are setGridLogLevel, setLogLevel, setGridLogLevelForFunctionalDomain, setLogLevelForFunctionalDomain
       # and updateSubscriberTraceConfiguration.
       #To persist the log level changes, update log4j2.logger.<loggerName> in override or value.yaml.
       command: ""
     resources: {}
   chargingSyCacheMigration:
     name: "charging-sy-cache-migration"
     syCacheMigration:
       runjob: "false"
       #rollback flag should be set to "true" only if rolling back to the ece version which doesn't support DiameterPersistedSySessionStore
       #cache coherenceAssociated keys.
       rollback: "false"
     resources: {}
   schemaLoader:
     resources: {}
# EM Gateway configuration
emgateway:
  # Fully Qualified Domain Name of the EM Gateway service
   serviceFqdn: "ece-emg"
   resources: {}
   emGatewayList:
      # First entry in the EM Gateway configuration list
      # Name within Coherence cluster
      - coherenceMemberName: "emgateway1"
        # JMX port for Java Management Extensions (left blank, indicating default or not used)
        jmxport: ""
        # Number of replica instances for this gateway
        replicas: 1
        # Enables JMX for monitoring and management
        jmxEnabled: true
        # Coherence cluster communication port (left blank, indicating default or not used)
        coherencePort:
        # JVM Garbage Collector options for performance tuning
        jvmGCOpts: "-XX:+UnlockExperimentalVMOptions -XX:+UseG1GC -XX:MaxGCPauseMillis=50 -XX:GCPauseIntervalMillis=200"
        # JVM options for JMX configuration
        jvmJMXOpts: "-Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false -Dcom.sun.management.jmxremote.local.only=false "
        # JVM options for Coherence configuration
        jvmCoherenceOpts: "-Dpof.config=charging-pof-config.xml -Dcoherence.override=charging-coherence-override-dev.xml  -Dcoherence.security=false -Dsecure.access.name=admin"
        # Additional JVM options, here enabling ECE metrics over HTTP
        jvmOpts: "-Dece.metrics.http.service.enabled=true -Dfile.encoding=UTF-8 --add-opens=java.base/java.time=ALL-UNNAMED --add-opens=java.base/java.util=ALL-UNNAMED"
        # Counter for the number of times the service has been restarted
        restartCount: "0"
        emGatewayConfiguration:
           # Name of this EM Gateway configuration
           name: "emgateway1"
           # Port number on which the EM Gateway listens
           port: "15502"
           # Size of the thread pool for handling incoming connections
           threadPoolSize: "10"
           # Indicates if SSL is enabled (1) or not (0)
           sslEnabled: "1"
           # Enables socket keep-alive feature (1) or not (0)
           socketKeepAlive: "1"
           # Path to the wallet for SSL configuration
           wallet: "/home/charging/wallet/brmwallet/server/cwallet.sso"
           # Indicates if client authentication is required (1) or not (0)
           clientAuthenticationEnabled: "0"
           # Timeout in milliseconds for update responses
           updateResponseTimeout: "30000"

      # Second entry in the EM Gateway configuration list
      # Similar configuration as emgateway1, with a unique Coherence cluster member name
      - coherenceMemberName: "emgateway2"
        jmxport: ""
        replicas: 1
        jmxEnabled: true
        coherencePort:
        jvmGCOpts: "-XX:+UnlockExperimentalVMOptions -XX:+UseG1GC -XX:MaxGCPauseMillis=50 -XX:GCPauseIntervalMillis=200"
        jvmJMXOpts: "-Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false -Dcom.sun.management.jmxremote.local.only=false "
        jvmCoherenceOpts: "-Dpof.config=charging-pof-config.xml -Dcoherence.override=charging-coherence-override-dev.xml  -Dcoherence.security=false -Dsecure.access.name=admin"
        jvmOpts: "-Dece.metrics.http.service.enabled=true -Dfile.encoding=UTF-8 --add-opens=java.base/java.time=ALL-UNNAMED --add-opens=java.base/java.util=ALL-UNNAMED"
        restartCount: "0"
        emGatewayConfiguration:
           name: "emgateway2"
           port: "15502"
           threadPoolSize: "10"
           sslEnabled: "1"
           socketKeepAlive: "1"
           wallet: "/home/charging/wallet/brmwallet/server/cwallet.sso"
           clientAuthenticationEnabled: "0"
           updateResponseTimeout: "30000"

#Radius Gateway configuration
radiusgateway:
   # Path to the wallet for SSL configuration
   wallet: "/home/charging/wallet/brmwallet/client/cwallet.sso"
   # Size of the processing queue
   queueSize: "8"
   # Attribute-Value Pair name for RADIUS
   avpName: "Service-Type"
   # Vendor ID for RADIUS attributes
   vendorId: "0"
   # Password for key
   keyPass: ""
   # Location of the keystore, if SSL is used
   keyStoreLocation: ""
   # Enable checking for retransmissions
   enableRetransmissionCheck: "true"
   # Time to live for messages in milliseconds
   timeToLive: "30000"
   # Connection pool size for notification listeners
   notificationListenerConnectionPoolSize: "10"
   # Maximum number of sessions for a user
   maxSessionsPerUser: "5"
   resources: {}
   radiusgatewayList:
     # Configuration for the first RADIUS Gateway instance
     # Name within Coherence cluster
      - coherenceMemberName: "radiusgateway1"
        # JMX port for Java Management Extensions (left blank, indicating default or not used)
        jmxport: ""
        # Number of replica instances for this gateway
        replicas: 1
        # Enable Java Management Extensions for monitoring
        jmxEnabled: true
        # Coherence cluster communication port (left blank, indicating default or not used)
        coherencePort:
        # JVM Garbage Collection options for tuning
        jvmGCOpts: "-XX:+UnlockExperimentalVMOptions -XX:+UseG1GC -XX:MaxGCPauseMillis=50 -XX:GCPauseIntervalMillis=200"
        # JVM options for JMX configuration
        jvmJMXOpts: "-Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false -Dcom.sun.management.jmxremote.local.only=false "
        # JVM options for Coherence configuration
        jvmCoherenceOpts: "-Dpof.config=charging-pof-config.xml -Dcoherence.override=charging-coherence-override-dev.xml  -Dcoherence.security=false -Dsecure.access.name=admin"
        # Additional JVM options, here enabling ECE metrics over HTTP
        jvmOpts: "-Dece.metrics.http.service.enabled=true -Dfile.encoding=UTF-8 --add-opens=java.base/java.time=ALL-UNNAMED --add-opens=java.base/java.util=ALL-UNNAMED"
        # Tracks the number of times the gateway has been restarted
        restartCount: "0"
        # The port on which the Radius service listens for incoming connections.
        radiusServiceNodePort: ""
        radiusGatewayConfiguration:
          # Name of this Radius Gateway configuration
           name: "radiusgateway1"
          # Port for RADIUS traffic
           radiusTrafficPort: "1812"
          # Size of the I/O thread pool
           ioThreadPoolSize: "16"
          # Number of challenge messages to be sent
           noOfChallenges: "1"
          # ECE wallet location
           eceWalletLocation: "/home/charging/wallet/brmwallet/client"
          # Port number of NAS client for sending disconnect messages
           disconnectMessagePort: "3799"
          # Batch size for Kafka processing
           kafkaBatchSize: "10"
          # Size of the scheduled thread pool executor to resend disconnect messages
           disconnectMessageRetryThreadPoolSize: "5"
          # Maximum retry count of a disconnect message
           disconnectMessageMaxRetryCount: "3"
          # Initial delay after which the retry mechanism is invoked
           disconnectMessageRetryDelayMillis: "3000"
          # Wait time for receiving a disconnect message response from network
           disconnectMessageResponseTimeoutMillis: "2000"

      # Second entry in the Radius Gateway configuration list
      # Similar configuration as radiusgateway1, with a unique Coherence cluster member name
      - coherenceMemberName: "radiusgateway2"
        jmxport: ""
        replicas: 1
        jmxEnabled: true
        coherencePort:
        jvmGCOpts: "-XX:+UnlockExperimentalVMOptions -XX:+UseG1GC -XX:MaxGCPauseMillis=50 -XX:GCPauseIntervalMillis=200"
        jvmJMXOpts: "-Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false -Dcom.sun.management.jmxremote.local.only=false "
        jvmCoherenceOpts: "-Dpof.config=charging-pof-config.xml -Dcoherence.override=charging-coherence-override-dev.xml  -Dcoherence.security=false -Dsecure.access.name=admin"
        jvmOpts: "-Dece.metrics.http.service.enabled=true -Dfile.encoding=UTF-8 --add-opens=java.base/java.time=ALL-UNNAMED --add-opens=java.base/java.util=ALL-UNNAMED"
        restartCount: "0"
        radiusServiceNodePort: ""
        radiusGatewayConfiguration:
           name: "radiusgateway2"
           radiusTrafficPort: "1812"
           ioThreadPoolSize: "16"
           noOfChallenges: "1"
           eceWalletLocation: "/home/charging/wallet/brmwallet/client"
           disconnectMessagePort: "3799"
           kafkaBatchSize: "10"
           disconnectMessageRetryThreadPoolSize: "5"
           disconnectMessageMaxRetryCount: "3"
           disconnectMessageRetryDelayMillis: "3000"
           disconnectMessageResponseTimeoutMillis: "2000"

#Diameter Gateway configuration
diametergateway:
   resources: {}
   diametergatewayList:
     # Configuration for the first Diameter Gateway instance
     # Name used within Coherence cluster for this member
      - coherenceMemberName: "diametergateway1"
        # JMX port for Java Management Extensions (left blank, indicating default or not used)
        jmxport: ""
        # Number of replica instances for this gateway
        replicas: 1
        # Enables JMX for monitoring and management
        jmxEnabled: true
        # Coherence cluster communication port (left blank, indicating default or not used)
        coherencePort:
        # JVM Garbage Collection options for tuning
        jvmGCOpts: "-XX:+UnlockExperimentalVMOptions -XX:+UseG1GC -XX:MaxGCPauseMillis=50 -XX:GCPauseIntervalMillis=200"
        # JVM options for JMX configuration
        jvmJMXOpts: "-Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false -Dcom.sun.management.jmxremote.local.only=false "
        # JVM options for Coherence configuration
        jvmCoherenceOpts: "-Dcoherence.role=OracleCommunicationBrmChargingEcegatewayDiameterGatewayLauncher -Dpof.config=charging-pof-config.xml -Dcoherence.override=charging-coherence-override-dev.xml  -Dcoherence.security=false -Dsecure.access.name=admin"
        # Additional JVM options, here enabling ECE metrics over HTTP
        jvmOpts: "-Dece.metrics.http.service.enabled=true -Dfile.encoding=UTF-8 --add-opens=java.base/java.time=ALL-UNNAMED --add-opens=java.base/java.util=ALL-UNNAMED"
        # Tracks the number of times the gateway has been restarted
        restartCount: "0"
        # The port on which the Diameter service listens for incoming connections.
        diameterServiceNodePort: ""
        # Node selector for deployment
        nodeSelector: ""
        diameterGatewayConfiguration:
           # Configuration name
           name: "diametergateway1"
           # clusterName determines site where ref pod is running.
           clusterName: "BRM"
           # Port for Diameter traffic
           diameterTrafficPort: "3868"
           # Size of the I/O thread pool
           ioThreadPoolSize: "10"
           # Timeout for responses in seconds
           responseTimeout: "10"
           # Interval for watchdog checks in seconds
           watchDogInterval: "30"
           # Origin host name for Diameter messages
           originHost: "ece.example.com"
           # Origin realm for Diameter messages
           originRealm: "example.com"
           # Specific host for Diameter traffic
           diameterTrafficHost: ""
           # Host for SCTP Diameter traffic
           diameterTrafficHostSctp: ""
           # Use loopback interface, typically for testing
           loopback: "false"
           # Thread pool size for processing requests
           requestProcessorThreadPoolSize: "10"
           # Batch size for processing requests
           requestProcessorBatchSize: "10"
           # Thread pool size for notifications
           notificationThreadPoolSize: "10"
           # Maximum size for committing notifications
           maxNotificationCommitSize: "100"
            # Maximum wait time for commiting notifications
           maxWaitTimeNotificationCommit: "3600000"
           # Failover support for Credit-Control
           ccFailover: "FAILOVER_SUPPORTED"
           # Handling for Credit-Control failures
           creditControlFailureHandling: "RETRY_AND_TERMINATE"
           # Handling for direct debiting failures
           directDebitingFailureHandling: "TERMINATE_OR_BUFFER"
           # Maximum inbound streams for SCTP, 0 for default
           sctpMaxInStream: "0"
           # Maximum outbound streams for SCTP, 0 for default
           sctpMaxOutStream: "0"
           # Send buffer size for SCTP, 0 for default
           sctpSendBufferSize: "0"
           # Receive buffer size for SCTP, 0 for default
           sctpReceiveBufferSize: "0"
           # Connection pool size for notification listeners
           notificationListenerConnectionPoolSize: "10"
           # Allow multiple connections per peer. Set to "true" to enable.
           allowMultipleConnectionsPerPeer: "false"
           # specifies the Kafka partition the notification listener should consume messages from.
           kafkaPartition: "3"
           dgwNotifNetworkResponseTimeoutAdder: "200"
           # The number of milliseconds beyond the creation time before a request is considered expired during processing
           ingressRequestTimeoutMs: "3000"
           # If true, expiration processing will use the value from the Event-Timestamp AVP
           enableNetworkExpiration: "true"

      # Second entry in the Diameter Gateway configuration list
      # Similar configuration as diametergateway1, with a unique Coherence cluster member name
      - coherenceMemberName: "diametergateway2"
        jmxport: ""
        replicas: 1
        jmxEnabled: true
        coherencePort:
        jvmGCOpts: "-XX:+UnlockExperimentalVMOptions -XX:+UseG1GC -XX:MaxGCPauseMillis=50 -XX:GCPauseIntervalMillis=200"
        jvmJMXOpts: "-Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false -Dcom.sun.management.jmxremote.local.only=false "
        jvmCoherenceOpts: "-Dcoherence.role=OracleCommunicationBrmChargingEcegatewayDiameterGatewayLauncher -Dpof.config=charging-pof-config.xml -Dcoherence.override=charging-coherence-override-dev.xml  -Dcoherence.security=false -Dsecure.access.name=admin"
        jvmOpts: "-Dece.metrics.http.service.enabled=true -Dfile.encoding=UTF-8 --add-opens=java.base/java.time=ALL-UNNAMED --add-opens=java.base/java.util=ALL-UNNAMED"
        restartCount: "0"
        diameterServiceNodePort: ""
        nodeSelector: ""
        diameterGatewayConfiguration:
           name: "diametergateway2"
           clusterName: "BRM"
           diameterTrafficPort: "3868"
           ioThreadPoolSize: "10"
           responseTimeout: "10"
           watchDogInterval: "30"
           originHost: "ece.example.com"
           originRealm: "example.com"
           diameterTrafficHost: ""
           diameterTrafficHostSctp: ""
           loopback: "false"
           requestProcessorThreadPoolSize: "10"
           requestProcessorBatchSize: "10"
           notificationThreadPoolSize: "10"
           maxNotificationCommitSize: "100"
           maxWaitTimeNotificationCommit: "3600000"
           ccFailover: "FAILOVER_SUPPORTED"
           creditControlFailureHandling: "RETRY_AND_TERMINATE"
           directDebitingFailureHandling: "TERMINATE_OR_BUFFER"
           sctpMaxInStream: "0"
           sctpMaxOutStream: "0"
           sctpSendBufferSize: "0"
           sctpReceiveBufferSize: "0"
           notificationListenerConnectionPoolSize: "10"
           allowMultipleConnectionsPerPeer: "false"
           kafkaPartition: "4"
           dgwNotifNetworkResponseTimeoutAdder: "200"
          # The number of milliseconds beyond the expiration time before a request is considered expired during processing
           ingressRequestTimeoutMs: "3000"
          # If true, expiration processing will use the value from the Event-Timestamp AVP
           enableNetworkExpiration: "true"

cdrgateway:
  resources: {}
  cdrgatewayList:
    # Configuration for the CDR Gateway instance
    # Name used within Coherence cluster for this member
    - coherenceMemberName: "cdrgateway1"
      # JMX port for Java Management Extensions (left blank, indicating default or not used)
      jmxport: ""
      # Number of replica instances for this gateway
      replicas: 0
      # Enables JMX for monitoring and management
      jmxEnabled: true
      # Coherence cluster communication port (left blank, indicating default or not used)
      coherencePort:
      # JVM Garbage Collection options for tuning
      jvmGCOpts: "-XX:+UnlockExperimentalVMOptions -XX:+UseG1GC -XX:MaxGCPauseMillis=50 -XX:GCPauseIntervalMillis=200"
      # JVM options for JMX configuration
      jvmJMXOpts: "-Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false -Dcom.sun.management.jmxremote.local.only=false "
      # JVM options for Coherence configuration
      jvmCoherenceOpts: "-Dpof.config=charging-pof-config.xml -Dcoherence.override=charging-coherence-override-dev.xml  -Dcoherence.security=false -Dsecure.access.name=admin"
      # Additional JVM options, here enabling ECE metrics over HTTP
      jvmOpts: "-Dece.metrics.http.service.enabled=true -Dfile.encoding=UTF-8 --add-opens=java.base/java.time=ALL-UNNAMED --add-opens=java.base/java.util=ALL-UNNAMED"
      # Tracks the number of times the gateway has been restarted
      restartCount: "0"
      cdrGatewayConfiguration:
        # Configuration name
        name: "cdrgateway1"
        #clusterName determines site where ref pod is running.
        clusterName: "BRM"
        # Name of the primary instance for this CDR Gateway
        primaryInstanceName: "cdrgateway1"
        # Schema version number
        schemaNumber: "1"
        # Whether NoSQL connection is used
        isNoSQLConnection: "true"
        # Name of the NoSQL connection
        noSQLConnectionName: "noSQLConnection"
        # Name of the database connection
        connectionName: "oraclePersistence1"
        # Port for CDR service
        cdrPort: "8084"
        # Hostname for the CDR service
        cdrHost: "ece-cdrgatewayservice"
        # Whether to handle CDRs individually. Set to "true" to enable.
        individualCdr: "false"
        # Core pool size for CDR server thread pool
        cdrServerCorePoolSize: "32"
        # Maximum pool size for CDR server thread pool
        cdrServerMaxPoolSize: "256"
        # Disabled detection of incomplete CDRs. Set to "true" to enable
        enableIncompleteCdrDetection: "false"
        # Disabled detection of duplicate CDRs due to retransmissions. Set to "true" to enable
        retransmissionDuplicateDetectionEnabled: "false"

httpgateway:
   # SSL keystore file for the server
   serverSslKeyStore: "httpGatewayServer.jks"
   # Name of the external secret containing server SSL keystore, if present
   extServerSSLKeyStoreSecret:
   # Type of the SSL keystore
   serverSslKeyStoreType: "PKCS12"
   # Alias for the key in the SSL keystore
   serverSslKeyStoreAlias: "oracle"
   # Wallet location for SSL configuration
   walletLocation: "/home/charging/wallet/ecewallet/"
   # Enable HTTP2 Server Name Indication
   snrHttp2Enable: "true"
   # Disabled generation of CDRs. Set to "true" to enable
   cdrGenerationEnabled: "false"
   # Standalone mode for CDR generation
   cdrGenerationStandaloneMode: "false"
   # List of CDR Gateway services
   cdrGatewayList: "ece-cdrgatewayservice:8084"
   # Number of retries for CDR Gateway communication
   cdrGatewayRetry: "3"
   # Interval between retries in milliseconds
   retryIntervalInMillis: "5000"
   # External HTTP port for the server
   serverHttpExternalPort: "31409"
   # Rate offline CDRs in real-time
   rateOfflineCDRinRealtime: "false"
   # Generate CDRs for online requests
   generateCDRsForOnlineRequests: "true"
   # Enable call screening feature
   callScreeningEnabled: "true"
   # Connection pool size for notification listeners
   notificationListenerConnectionPoolSize: "10"
   ecsClusterHealthStatus: ""
   # SSL identity keystore file for the server
   httpIdentityKeystore: ""
   # Name of the external secret containing HTTP identity Key store, if present
   extHttpIdentityKeystoreSecret:
   # Type of the SSL identity keystore
   httpIdentityKeystoreType: ""
   # SSL truststore file
   httpTruststore: ""
   # Name of the external secret containing HTTP Trust store, if present
   extHttpTruststoreSecret:
   # Type of the SSL truststore
   httpTruststoreType: ""
   # Public Key Path of NRF so that JWT can be validated
   nrfPublicKeyLocation: ""
   # Name of the external secret containing NRF public key, if present
   extNrfPublicKeyLocationSecret:
   # Algorithm used to create the NRF Public Key. Valid Values: RSA,EC. Default value is RSA
   nrfJwtAlgorithm: "RSA"
   resources: {}
   httpgatewayList:
      # Configuration for the first HTTP Gateway instance
      # Name used within Coherence cluster for this member
      - coherenceMemberName: "httpgateway1"
        # JMX port for Java Management Extensions (left blank, indicating default or not used)
        jmxport: ""
        # Number of replica instances for this gateway
        replicas: 0
        # Maximum number of replicas for auto-scaling
        maxreplicas: 0
        # CPU utilization threshold for auto-scaling
        averageCpuUtilization: 70
        # Memory utilization threshold for auto-scaling
        averageMemoryUtilization: ""
        # Stabilization window before scaling down
        scaleDownStabilizationWindowSeconds: 120
        # Disable Horizontal Pod Autoscaler scaling down
        disableHpaScaleDown: "false"
        # Enable Java Management Extensions for monitoring
        jmxEnabled: true
        # Coherence cluster communication port (left blank, indicating default or not used)
        coherencePort:
        # JVM Garbage Collection options for tuning
        jvmGCOpts: "-XX:+UnlockExperimentalVMOptions -XX:+UseG1GC -XX:MaxGCPauseMillis=50 -XX:GCPauseIntervalMillis=200"
        # JVM options for JMX configuration
        jvmJMXOpts: "-Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false -Dcom.sun.management.jmxremote.local.only=false "
        # JVM options for Coherence configuration
        jvmCoherenceOpts: "-Dpof.config=charging-pof-config.xml -Dcoherence.override=charging-coherence-override-dev.xml  -Dcoherence.security=false -Dsecure.access.name=admin"
        # Additional JVM options, here enabling ECE metrics over HTTP
        jvmOpts: "-Dece.metrics.http.service.enabled=true -Dfile.encoding=UTF-8 --add-opens=java.base/java.time=ALL-UNNAMED --add-opens=java.base/java.util=ALL-UNNAMED"
        # Tracks the number of times the gateway has been restarted
        restartCount: "0"
        httpGatewayConfiguration:
           # Configuration name
           name: "httpgateway1"
           # clusterName determines site where ref pod is running.
           clusterName: "BRM"
           # Enable HTTP/2 server
           serverHttp2Enabled: "true"
           # Secure server port for HTTPS
           serverPort: "8443"
           # Server port for HTTP
           serverHttpPort: "8080"
           # Number of retries for NRF heartbeats
           nrfHeartBeatRetryCount: "4"
           # Disabled SSL for the server. Set to "true" to enable
           serverSslEnabled: "false"
           # Size of the processing thread pool
           processingThreadPoolSize: "200"
           # Size of the processing queue
           processingQueueSize: "32768"
           # Batch size for Kafka processing
           kafkaBatchSize: "10"
           # External traffic information
           externalTrafficInfo: ""
           # Interval (in seconds) between NRF retries
           nrfRetryIntervalInSecond: "60"
           # Number of retries for NRF requests
           nrfRetryCount: "3"
           # Number of Kafka partitions used
           kafkaPartition: "5"
           # SCP authorities, if applicable
           scpAuthorities: ""
           # Disabled SSL for the PCF. Set to "true" to enable
           pcfSSLEnabled: "false"
           # Disabled SSL for the NRF. Set to "true" to enable
           nrfSSLEnabled: "false"
           # Disabled SSL for the SMF. Set to "true" to enable
           smfSSLEnabled: "false"
           # Type of  SSL configuration (Set to "twoway" for mutual SSL, or "oneway")
           httpSSLType: ""
          # Enable to allow OAuth2 support. Default value is false
           oauth2Enabled: "false"
          # The number of milliseconds beyond the creation time before a request is considered expired during processing
           ingressRequestTimeoutMs: "3000"
          # If true, expiration processing will use the time from the incoming payload
           enableNetworkExpiration: "true"

      # Second entry in the HTTP Gateway configuration list
      # Similar configuration as httpgateway1, with a unique Coherence cluster member name
      - coherenceMemberName: "httpgateway2"
        jmxport: ""
        replicas: 0
        maxreplicas: 0
        averageCpuUtilization: 70
        averageMemoryUtilization: ""
        scaleDownStabilizationWindowSeconds: 120
        disableHpaScaleDown: "false"
        jmxEnabled: true
        coherencePort:
        jvmGCOpts: "-XX:+UnlockExperimentalVMOptions -XX:+UseG1GC -XX:MaxGCPauseMillis=50 -XX:GCPauseIntervalMillis=200"
        jvmJMXOpts: "-Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false -Dcom.sun.management.jmxremote.local.only=false "
        jvmCoherenceOpts: "-Dpof.config=charging-pof-config.xml -Dcoherence.override=charging-coherence-override-dev.xml  -Dcoherence.security=false -Dsecure.access.name=admin"
        jvmOpts: "-Dece.metrics.http.service.enabled=true -Dfile.encoding=UTF-8 --add-opens=java.base/java.time=ALL-UNNAMED --add-opens=java.base/java.util=ALL-UNNAMED"
        restartCount: "0"
        httpGatewayConfiguration:
           name: "httpgateway2"
           clusterName: "BRM"
           serverHttp2Enabled: "true"
           serverPort: "8443"
           serverHttpPort: "8080"
           managementServerPort: "9000"
           nrfHeartBeatRetryCount: "4"
           serverUndertowWorkerThreads:  "32"
           serverSslEnabled: "false"
           processingThreadPoolSize: "200"
           processingQueueSize: "32768"
           http2MaxConcurrentStreams: "-1"
           http2InitialWindowSize: "-1"
           kafkaBatchSize: "10"
           externalTrafficInfo: ""
           nrfRetryIntervalInSecond: "60"
           nrfRetryCount: "3"
           kafkaPartition: "6"
           scpAuthorities: ""
           # Disabled SSL for the PCF. Set to "true" to enable
           pcfSSLEnabled: "false"
           # Disabled SSL for the NRF. Set to "true" to enable
           nrfSSLEnabled: "false"
           # Disabled SSL for the SMF. Set to "true" to enable
           smfSSLEnabled: "false"
           # Type of  SSL configuration (Set to "twoway" for mutual SSL, or "oneway")
           httpSSLType: ""
           oauth2Enabled: "false"
          # The number of milliseconds beyond the expiration time before a request is considered expired during processing
           ingressRequestTimeoutMs: "3000"
          # If true, expiration processing will use the time from the incoming payload
           enableNetworkExpiration: "true"

customerUpdater:
   resources: {}
   customerUpdaterList:
      # Configuration for the Customer Updater service
      # Schema number for database interaction
      - schemaNumber: "1"
        # Coherence cluster member name
        coherenceMemberName: "customerupdater1"
        # Number of replica instances
        replicas: 1
        # Enable Java Management Extensions for monitoring
        jmxEnabled: true
        # Coherence cluster communication port (left blank, indicating default or not used)
        coherencePort: ""
        # JVM Garbage Collection options for tuning
        jvmGCOpts: "-XX:+UnlockExperimentalVMOptions -XX:+UseG1GC -XX:MaxGCPauseMillis=50 -XX:GCPauseIntervalMillis=200"
        # JVM options for JMX configuration
        jvmJMXOpts: "-Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false -Dcom.sun.management.jmxremote.local.only=false "
        # JVM options for Coherence configuration
        jvmCoherenceOpts: "-Dpof.config=charging-pof-config.xml -Dcoherence.override=charging-coherence-override-dev.xml  -Dcoherence.security=false -Dsecure.access.name=admin"
        # Additional JVM options, here enabling ECE metrics over HTTP
        jvmOpts: "-Dece.metrics.http.service.enabled=true -DcontinueCustomerLoaderOnError=true -Dfile.encoding=UTF-8 --add-opens=java.base/java.time=ALL-UNNAMED --add-opens=java.base/java.util=ALL-UNNAMED"
        # JMX port for Java Management Extensions (left blank, indicating default or not used)
        jmxport: ""
        # Tracks the number of times this customerUpdater has been restarted
        restartCount: "0"
        oracleQueueConnectionConfiguration:
           # Configuration name
           name: "customerupdater1"
           # Gateway name for database connection
           gatewayName: "customerupdater1"
           # Database host name
           hostName: "${DBHOST}"
           # Database port
           port: "1521"
           #if CN Database service doesn't support sid, then set sid as "" and provide correct jdbc url instead.
           sid: "pindb"
           # Database user name
           userName: "pin"
           # JDBC URL for database connection, if SID not used
           jdbcUrl: "jdbc:oracle:thin:@${DBHOST}:1521/${DBSERVICE}"
           # Queue name for sync operations
           queueName: "IFW_SYNC_QUEUE"
           # Queue name for suspense operations
           suspenseQueueName: "ECE_SUSPENSE_QUEUE"
           # Queue name for acknowledgment operations
           ackQueueName: "ECE_ACK_QUEUE"
           # Queue name for amount acknowledgment operations
           amtAckQueueName: "ECE_AMT_ACK_QUEUE"
           # Disabled SSL for database connection. Set to "true" to enable
           dbSSLEnabled: "false"
           # TLS version used for database connection
           tlsVersion: "1.3"
           # Type of database SSL configuration (e.g., "twoway" for mutual SSL)
           dbSSLType: "oneway"
           # Distinguished Name (DN) of the server SSL certificate for database connection
           sslServerCertDN: "DC=local,DC=oracle,CN=pindb"
           # Trust store location for SSL
           trustStoreLocation: "/home/charging/ext/ece_ssl_db_wallet/schema1/cwallet.sso"
           # Trust store type
           trustStoreType: "SSO"
           # Batch size for processing
           batchSize: "1"
           # Database timeout in seconds
           dbTimeout: "900"
           # Number of retries for database operations
           retryCount: "10"
           # Interval between retries in seconds
           retryInterval: "60"
           # Wallet location for SSL configuration
           walletLocation: "/home/charging/wallet/ecewallet/"
           # Location of Oracle files used for database connections or configurations (e.g., Oracle Database Resource Manager files)
           oraFilesLocation: "/home/charging/ext/ora_files/brm/"
           # Name of the external secret containing SSL Trust store, if present
           extBRMDBSSLWalletSecret:

ratedEventFormatter:
   resources: {}
   ratedEventFormatterList:
      # Configuration for the Rated Event Formatter service
      # Schema number for database interaction
      - schemaNumber: "1"
        # Number of replica instances
        replicas: 1
        # Coherence cluster member name
        coherenceMemberName: "ratedeventformatter1"
        # Enable Java Management Extensions for monitoring
        jmxEnabled: true
        # Coherence cluster communication port (left blank, indicating default or not used)
        coherencePort:
        # JVM Garbage Collection options for tuning
        jvmGCOpts: "-XX:+UnlockExperimentalVMOptions -XX:+UseG1GC -XX:MaxGCPauseMillis=50 -XX:GCPauseIntervalMillis=200"
        # JVM options for JMX configuration
        jvmJMXOpts: "-Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false -Dcom.sun.management.jmxremote.local.only=false "
        # JVM options for Coherence configuration
        jvmCoherenceOpts: "-Dpof.config=charging-pof-config.xml -Dcoherence.override=charging-coherence-override-dev.xml  -Dcoherence.security=false -Dsecure.access.name=admin"
        # Additional JVM options, including REM log base path
        jvmOpts: "-Dece.metrics.http.service.enabled=true -Dfile.encoding=UTF-8 --add-opens=java.base/java.time=ALL-UNNAMED --add-opens=java.base/java.util=ALL-UNNAMED"
        # JMX port for Java Management Extensions (left blank, indicating default or not used)
        jmxport: ""
        # Tracks the number of times this ratedEventFormatter has been restarted
        restartCount: "0"
        # Node selector for deployment
        nodeSelector: ""
        ratedEventFormatterConfiguration:
           # Configuration name
           name: "ratedeventformatter1"
           # clusterName determines site where ref pod is running.
           clusterName: "BRM"
           # Name of the primary instance
           primaryInstanceName: "ratedeventformatter1"
           # Partition number for data segmentation
           partition: "1"
           # Name of the NoSQL connection
           noSQLConnectionName: "noSQLConnection"
           # Name of the database connection
           connectionName: "oraclePersistence1"
           # Size of the thread pool for processing
           threadPoolSize: "6"
           # Duration to retain data, 0 for indefinitely
           retainDuration: "0"
           # Duration until data is considered ripe for processing in seconds
           ripeDuration: "600"
           # Interval for checkpointing in seconds
           checkPointInterval: "6"
           # Maximum time for persistence catch-up, 0 for no limit
           maxPersistenceCatchupTime: "0"
           #parameter siteName, Each REF instance is supposed to handle the rated events for, in ECE active-active setup.
           #The siteName is to determine which RatedEvent DB table to use.
           #For the primary REF running in a site1 (BRM) and secondary REF instances running the remote sites (BRM2), siteName parameter value is BRM and RatedEvent DB table to use is RatedEvent_BRM.
           siteName: ""
           # use remCdrPlugin and jar to integrate with REM
           #pluginPath: "brm-rated-event-manager-12.0.0.4.1.jar"
           #pluginType: "com.oracle.brm.ref_brm_plugin.RatedEventManagerCdrPlugin"
           pluginPath: "ece-ratedeventformatter.jar"
           pluginType: "oracle.communication.brm.charging.ratedevent.formatterplugin.internal.BrmCdrPluginDirect"
           pluginName: "brmCdrPlugin1"
           noSQLBatchSize: "25"

cdrFormatter:
  resources: {}
  cdrFormatterList:
   # Configuration for the cdr Formatter service
   # Schema number for database interaction
   - schemaNumber: "1"
     # Number of replica instances
     replicas: 1
     # Coherence cluster member name
     coherenceMemberName: "cdrformatter1"
     # Enable Java Management Extensions for monitoring
     jmxEnabled: true
     # Coherence cluster communication port (left blank, indicating default or not used)
     coherencePort:
     # JVM Garbage Collection options for tuning
     jvmGCOpts: "-XX:+UnlockExperimentalVMOptions -XX:+UseG1GC -XX:MaxGCPauseMillis=50 -XX:GCPauseIntervalMillis=200"
     # JVM options for JMX configuration
     jvmJMXOpts: "-Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false -Dcom.sun.management.jmxremote.local.only=false "
     # JVM options for Coherence configuration
     jvmCoherenceOpts: "-Dpof.config=charging-pof-config.xml -Dcoherence.override=charging-coherence-override-dev.xml  -Dcoherence.security=false -Dsecure.access.name=admin"
     # Additional JVM options, here enabling ECE metrics over HTTP
     jvmOpts: "-Dece.metrics.http.service.enabled=true -Dfile.encoding=UTF-8 --add-opens=java.base/java.time=ALL-UNNAMED --add-opens=java.base/java.util=ALL-UNNAMED"
     # JMX port for Java Management Extensions (left blank, indicating default or not used)
     jmxport: ""
     # Tracks the number of times this ratedEventFormatter has been restarted
     restartCount: "0"
     # Node selector for deployment
     nodeSelector: ""
     cdrFormatterConfiguration:
       # Configuration name
       name: "cdrformatter1"
       #clusterName determines site where ref pod is running.
       clusterName: "BRM"
       # Name of the primary instance
       primaryInstanceName: "cdrformatter1"
       # Schema number for database interaction
       schemaNumber: "1"
       # Whether NoSQL connection is used
       isNoSQLConnection: "true"
       # Name of the NoSQL connection
       noSQLConnectionName: "noSQLConnection"
       # Name of the database connection
       connectionName: "oraclePersistence1"
       # Size of the thread pool for processing
       threadPoolSize: "6"
       # Duration to retain data, 0 for indefinitely
       retainDuration: "0"
       # Duration until data is considered ripe for processing in seconds
       ripeDuration: "60"
       # Interval for checkpointing in seconds
       checkPointInterval: "6"
       # Maximum time for persistence catch-up, 0 for no limit
       maxPersistenceCatchupTime: "0"
       # Specifies the path to a Java Archive (JAR) file
       pluginPath: "ece-cdrformatter.jar"
       # Indicates the fully qualified class name of the plugin implementation.
       pluginType: "oracle.communication.brm.charging.cdr.formatterplugin.internal.SampleCdrFormatterCustomPlugin"
       pluginName: "cdrFormatterPlugin1"
       noSQLBatchSize: "25"
       # Defines the fetch size for retrieving CDRs (Call Detail Records) from storage
       cdrStoreFetchSize: "2500"
       # Specifies the age (in seconds) at which orphaned CDR records should be cleaned up
       cdrOrphanRecordCleanupAgeInSec: "200"
       # Determines the sleep interval (in seconds) for the cleanup process mentioned above
       cdrOrphanRecordCleanupSleepIntervalInSec: "200"
       # flag indicating whether incomplete CDR detection is enabled or not.
       enableIncompleteCdrDetection: "false"

brmGateway:
   resources: {}
   brmGatewayList:
      # Configuration for the brmgateway instance
      # Schema number for database interaction
      - schemaNumber: "1"
        # Number of replica instances
        replicas: 1
        # Coherence cluster member name
        coherenceMemberName: "brmgateway1"
        # Enable Java Management Extensions for monitoring
        jmxEnabled: true
        # Coherence cluster communication port (left blank, indicating default or not used)
        coherencePort:
        # JVM Garbage Collection options for tuning
        jvmGCOpts: "-XX:+UnlockExperimentalVMOptions -XX:+UseG1GC -XX:MaxGCPauseMillis=50 -XX:GCPauseIntervalMillis=200"
        # JVM options for JMX configuration
        jvmJMXOpts: "-Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false -Dcom.sun.management.jmxremote.local.only=false "
        # JVM options for Coherence configuration
        jvmCoherenceOpts: "-Dcoherence.role=OracleCommunicationBrmChargingIntegrationsBRMGatewayLauncher -Dpof.config=charging-pof-config.xml -Dcoherence.override=charging-coherence-override-dev.xml  -Dcoherence.security=false -Dsecure.access.name=admin"
        # Additional JVM options, here enabling ECE metrics over HTTP
        jvmOpts: "-Dece.metrics.http.service.enabled=true -Dfile.encoding=UTF-8 --add-opens=java.base/java.time=ALL-UNNAMED --add-opens=java.base/java.util=ALL-UNNAMED"
        # Tracks the number of times this brmGateway has been restarted
        restartCount: "0"
        # JMX port for Java Management Extensions (left blank, indicating default or not used)
        jmxport: ""
        brmGatewayConfiguration:
           # Configuration name
           name: "brmgateway1"
           # clusterName determines site where ref pod is running.
           clusterName: "BRM"
           # Specifies the sleep interval (in milliseconds) for a thread responsible for handling empty queues.
           emptyQueueThreadSleepInterval: "50"
           # Sets the sleep interval (in milliseconds) for a JMS (Java Message Service) receive operation.
           jmsReceiveSleepInterval: "100"
           # The timeout interval (in milliseconds) for receiving a response from a BRM (Billing and Revenue Management) system
           brmResponseTimeOutInterval: "600000"
           gatewaySleepInterval: "2000"
           jmsBatchSize: "10"
           jmsReceiveTimeout: "2000"
           # Indicates the number of worker threads allocated for handling tasks related to BRM (Billing and Revenue Management) operations.
           brmWorkerThreads: "10"
           # Specifies the initial delay before starting a scheduler thread related to BRM operations.
           brmSchedulerThreadInitialDelay: "10"
           # Specifies the delay period between successive executions of the scheduler thread for BRM operations.
           brmSchedulerThreadDelayPeriod: "3"
           # Defines the period after which items in the suspense queue related to BRM operations are processed.
           brmSuspenseQueuePeriod: "1800000"
           # Specifies the number of retry attempts for establishing a connection. If a connection attempt fails, the system may retry up to this number of times.
           connectionRetryCount: "10"
           # Specifies the interval between retry attempts for establishing a connection.
           connectionRetryInterval: "10000"
           # Number of Kafka partitions used
           kafkaPartition: "1"
monitoringAgent:
   resources: {}
   monitoringAgentList:
      # Configuration name
      - coherenceMemberName: "monitoringagent1"
        # Number of replica instances
        replicas: 1
        # JMX port for Java Management Extensions (left blank, indicating default or not used)
        jmxport: ""
        # Enable Java Management Extensions for monitoring
        jmxEnabled: "true"
        # JVM options for JMX configuration
        jvmJMXOpts: "-Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false -Dcom.sun.management.jmxremote.local.only=false  -Dcom.sun.management.jmxremote.password.file=../config/jmxremote.password -Dsecure.access.name=admin -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.port=9090 -Dcom.sun.management.jmxremote.rmi.port=9090"
        # Instructs Java applications to prefer IPv4 addresses over other available addresses.
        jvmOpts: "-Djava.net.preferIPv4Addresses=true -Dfile.encoding=UTF-8 --add-opens=java.base/java.time=ALL-UNNAMED --add-opens=java.base/java.util=ALL-UNNAMED"
        # JVM Garbage Collection options for tuning
        jvmGCOpts: ""
        # Tracks the number of times this monitoringAgent has been restarted
        restartCount: "0"
        # Node selector for deployment
        nodeSelector: ""
      # Second entry in this monitoringAgent list
      # Similar configuration as monitoringagent1
      - name: "monitoringagent2"
        replicas: 1
        jmxport: ""
        jmxEnabled: "true"
        jvmJMXOpts: "-Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false -Dcom.sun.management.jmxremote.local.only=false  -Dcom.sun.management.jmxremote.password.file=../config/jmxremote.password -Dsecure.access.name=admin -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.port=9090 -Dcom.sun.management.jmxremote.rmi.port=9090"
        jvmOpts: "-Djava.net.preferIPv4Addresses=true -Dfile.encoding=UTF-8 --add-opens=java.base/java.time=ALL-UNNAMED --add-opens=java.base/java.util=ALL-UNNAMED"
        jvmGCOpts: ""
        restartCount: "0"
        nodeSelector: ""
charging:
   # Identifier label for charging component
   labels: "ece"
   # Port for Java Management Extensions (JMX) for management and monitoring
   jmxport: "31022"
   # Coherence cluster communication port (left blank, indicating default or not used)
   coherencePort: ""
   # Time to wait before forcefully terminating the pod
   terminationGracePeriodSeconds: 180
   # Enables data persistence
   persistenceEnabled: "true"
   # Enables rebuilding of cdrStore table
   rebuildCdrStoreTable: "false"
   # Horizontal Pod Autoscaler (HPA) is disabled.
   hpaEnabled: "false"
   # Remote Event Monitoring (REM) is disabled
   remEnabled: "false"
   #set incrementalCustomerLoad to "true" and migration.loader.initialCustomerLoadFilterQuery to load initial set of subscribers in ece cache on fresh install and
   #set migration.loader.incrementalCustomerLoadFilterQuery to load subscribers incrementally using customerloader job on helm upgrade after ECE is in usage processing state.
   #changing incrementalCustomerLoad from "false" to "true" or vice versa after ECE is up, can cause customerUpdater pod(s) to restart.
   incrementalCustomerLoad: "false"
   parallelPodManagement: "false"
   timeoutSurvivorQuorum: "3"
   chargingServerWorkerNodes: "3"
   clusterDomain: ""
   # if autoGenerateAppConfig is set, then diameterGatewayConfig, cdrFormatterConfiguration, cdrGatewayConfiguration, httpGatewayConfig,
   # nfProfileConfig, nfServiceConfig, brmGatewayConfiguration will automatically replicated for all sites in charging-settings.xml same as primary site.
   # this doesn't generate ratedEventFormatterConfiguration, oraclePersistence, cachePersistence, ratedEventPublisher, kafka configuration, JMSConfiguration, siteConfig and customerGroupConfig. it must be defined in override file for each site.
   # if autoGenerateAppConfig is disabled, then all pods configuration, other appConfigs for all sites must be configured in override file in active-active set up. Make sure coherence members are unique in each site.
   # autoGenerateAppConfig is mainly set for large systems to automatically generate some app config.
   autoGenerateAppConfig: "true"
   metrics:
      port: "19612"
   ecs:
     jmxport: ""
     # out of total configured replicas of ecs statefulset, first few replica(s) will be management enabled.
     # value of managementEnabledReplicas attribute must be at least 1 and less than replicas attribute of ecs.
     replicas: 1
     maxreplicas: 2
     managementEnabledReplicas: 1
     # Target CPU utilization percentage for autoscaling
     averageCpuUtilization: 70
     # Memory utilization threshold for auto-scaling
     averageMemoryUtilization: ""
     resources: {}
     # Window before scaling down
     scaleDownStabilizationWindowSeconds: 120
     # Allows HPA to scale down
     disableHpaScaleDown: "false"
     # Name for coherence member
     coherenceMemberName: "ecs"
     # Enables JMX
     jmxEnabled: true
     # Coherence cluster communication port (left blank, indicating default or not used)
     coherencePort:
     # Flag to enable Coherence Reporting
     enableCoherenceReporting: "false"
     # JVM Garbage Collection options for tuning
     jvmGCOpts: "-XX:+UnlockExperimentalVMOptions -XX:+UseG1GC -XX:MaxGCPauseMillis=50 -XX:GCPauseIntervalMillis=200"
     # JVM options for JMX configuration
     jvmJMXOpts: "-Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false -Dcom.sun.management.jmxremote.local.only=false "
     # JVM options for Coherence configuration
     jvmCoherenceOpts: "-Dcoherence.role=OracleCommunicationBrmChargingServerChargingLauncher -Dpof.config=charging-pof-config.xml -Dcoherence.override=charging-coherence-override-dev.xml  -Dcoherence.security=false -Dsecure.access.name=admin -Dcoherence.rwbm.writebehind.remove.default=true"
     # Additional JVM options, here enabling ECE metrics over HTTP
     jvmOpts: "-Dece.metrics.http.service.enabled=true -Dfile.encoding=UTF-8 --add-opens=java.base/java.time=ALL-UNNAMED --add-opens=java.base/java.util=ALL-UNNAMED"
     # Tracks the number of times this has been restarted
     restartCount: "0"
   # Same configuration like above for 'pricingupdater', 'configLoader', 'customerLoader' and 'query'.
   pricingupdater:
      jmxport: ""
      replicas: 1
      coherenceMemberName: "pricingupdater"
      jmxEnabled: true
      coherencePort:
      jvmGCOpts: "-XX:+UnlockExperimentalVMOptions -XX:+UseG1GC -XX:MaxGCPauseMillis=50 -XX:GCPauseIntervalMillis=200"
      jvmJMXOpts: "-Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false -Dcom.sun.management.jmxremote.local.only=false "
      jvmCoherenceOpts: "-Dpof.config=charging-pof-config.xml -Dcoherence.override=charging-coherence-override-dev.xml  -Dcoherence.security=false -Dsecure.access.name=admin"
      jvmOpts: "-Dece.metrics.http.service.enabled=true -Dfile.encoding=UTF-8 --add-opens=java.base/java.time=ALL-UNNAMED --add-opens=java.base/java.util=ALL-UNNAMED"
      restartCount: "0"
      resources: {}
   configLoader:
      coherenceMemberName: "configloader"
      jmxEnabled: false
      jvmGCOpts: "-XX:+UnlockExperimentalVMOptions -XX:+UseG1GC -XX:MaxGCPauseMillis=50 -XX:GCPauseIntervalMillis=200"
      jvmJMXOpts: "-Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false -Dcom.sun.management.jmxremote.local.only=false "
      jvmCoherenceOpts: "-Dpof.config=charging-pof-config.xml -Dcoherence.override=charging-coherence-override-dev.xml  -Dcoherence.security=false -Dsecure.access.name=admin"
      jvmOpts: " -Dfile.encoding=UTF-8 --add-opens=java.base/java.time=ALL-UNNAMED --add-opens=java.base/java.util=ALL-UNNAMED"
      coherencePort:
      resources: {}
   customerLoader:
      coherenceMemberName: "customerloader"
      jvmGCOpts: "-XX:+UnlockExperimentalVMOptions -XX:+UseG1GC -XX:MaxGCPauseMillis=50 -XX:GCPauseIntervalMillis=200"
      jvmCoherenceOpts: "-Dpof.config=charging-pof-config.xml -Dcoherence.override=charging-coherence-override-dev.xml  -Dcoherence.security=false -Dsecure.access.name=admin"
      jvmOpts: "-DcontinueCustomerLoaderOnError=true -Dfile.encoding=UTF-8 --add-opens=java.base/java.time=ALL-UNNAMED --add-opens=java.base/java.util=ALL-UNNAMED"
      coherencePort:
   query:
      jvmJMXOpts: "-Dcom.sun.management.jmxremote.password.file=../config/jmxremote.password -Dsecure.access.name=admin -Dcom.sun.management.jmxremote.authenticate=false"
      jvmCoherenceOpts: "-Dtangosol.pof.config=charging-pof-config.xml -Dtangosol.coherence.override=charging-coherence-override-dev.xml -Dtangosol.coherence.security=false -Dsecure.access.name=admin -Dtangosol.coherence.log.level=9 -Djava.security.auth.login.config=../config/coherence-jaas.config -Dtangosol.coherence.security.permissions=../config/permissions.xml"
      jvmOpts: "-Djava.net.preferIPv4Addresses=true -Dfile.encoding=UTF-8 --add-opens=java.base/java.time=ALL-UNNAMED --add-opens=java.base/java.util=ALL-UNNAMED"
   # clusterName determines site where ref pod is running.
   clusterName: "BRM"
   isFederation: "false"
   # Marks the cluster as primary in an active-active setup
   activeCluster: "true"
   # Indicates there is no secondary cluster in use
   secondaryCluster: "false"
   # Topology type of the cluster
   clusterTopology: "active-active"
   cluster:
      primary:
         # clusterName determines site where ref pod is running.
         clusterName: "BRM"
         # Service name for the ECE server in the primary cluster
         eceServiceName: ece-server
         # Indicates no specific FQDN or External IP address has been provided for this cluster.
         eceServicefqdnOrExternalIP: ""
      secondary:
        #clusterName determines site where ref pod is running.
        - clusterName: "BRM2"
          eceServiceName: ""
          # Indicates no specific FQDN or External IP address has been provided for this cluster.
          eceServicefqdnOrExternalIP: ""
   journalingConfig:
     journalManagerDirectoryPath: /tmp
     flashJournalMaxSize: 10GB
     ramJournalMaxSize: 10%
   federatedCacheScheme:
     threadCount:
       brmFederated: 32
       xrefFederated: 8
       replicatedFederated: 1
       offerProfileFederated: 1
     journalCacheHighUnits:
       brmJournalCacheHighUnits: 8GB
       xreffederatedJournalCacheHighUnits: 500MB
       replicatedfederatedJournalCacheHighUnits: 500MB
       offerProfileFederatedJournalCacheHighUnits: 500MB
     federationPort:
         # Federation port for BRM
         brmfederated: 31016
         # Federation port for XREF
         xreffederated: 31017
         # Unique identifier for the federated replication setup
         replicatedfederated: 31018
         # Unique identifier for federated offer profiles
         offerProfileFederated: 31019
   # Path to the ECE wallet directory
   eceWalletLocation: "/home/charging/wallet/ecewallet/"
   # Path to the BRM wallet server location
   brmWalletServerLocation: "/home/charging/wallet/brmwallet/server/cwallet.sso"
   # Path to the BRM wallet client location
   brmWalletClientLocation: "/home/charging/wallet/brmwallet/client/cwallet.sso"
   # Path to the BRM wallet directory
   brmWalletLocation: "/home/charging/wallet/brmwallet"
   # Indicates if a custom SSL wallet is used
   customSSLWallet: false
   secretCustomWallet:
      name:
   server:
      # Determines if Advanced Overcharging Protection is enabled
      aopEnabled: "false"
      # Allowed variance for AOP calculations
      aopVariance: "PT10M"
      # Threshold for entering degraded mode
      degradedModeThreshold: "0"
      # Determines if reverse rating should use all balances
      reverseRateUseAllBalances: "false"
      # Size of the eviction cache for debit refund sessions
      debitRefundSessionEvictionSize: "10"
      # Number of decimal places for currency values
      currencyScale: "2"
      # Rounding mode for currency calculations
      currencyRoundingMode: "HALF_UP"
      # Number of decimal places for non-currency values
      nonCurrencyScale: "2"
      # Rounding mode for non-currency calculations
      nonCurrencyRoundingMode: "HALF_UP"
      # Enables non-linear rating
      nonLinearRatingEnabled: "false"
      # Supports tariff time changes
      tariffTimeChangeSupported: "false"
      # Rule for system consumption
      systemConsumptionRule: "EARLIEST_START_EARLIEST_EXPIRATION"
      # Notification mode for threshold breaches
      thresholdBreachNotificationMode: "ON_TERMINATE"
      accountingOnOffMode: "CANCEL"
      # How offer eligibility is determined
      offerEligibilitySelectionMode: "END_TIME"
      offerSelectionModeOnEquiPriorityOffers: "START_TIME"
      # Aligns recurring impacts to offer start times
      alignRecurringImpactsToOffer: "false"
      # Number of retries for sharing operations
      sharingRetryCount :  "1"
      # Mode for calculating remaining balance
      remainingBalanceCalcMode: "NONE"
      # Virtual time setting for testing
      virtualTime: ""
      virtualTimeMode: "0"
      # Sleep time between concurrent rated events in federated mode
      concurrentRatedEventFederatedSleepTime: "0"
      systemCurrencyNumericCode: "840"
      # Treats absence of a rating graph as an error
      treatNoRatingGraphAsError: "true"
      # Enables match factor calculations
      matchFactorEnabled: "false"
      # Skips check for credit floor breaches
      skipCreditFloorBreachCheck: "false"
      # Determines if zero quantity should be rated
      rateZeroQuantity: "false"
      # Enables group notifications
      groupNotificationEnabled: "false"
      # Enables post-commit operations for BRM
      brmPostCommitEnabled: "false"
      # Timeout for update requests in milliseconds
      updateRequestServerTimeout: "20000"
      # Fails balance updates on credit ceiling breach
      failBalanceUpdatesOnCreditCeilingBreach: "false"
      # List of operations for ASO cleanup
      asoCleanupOperationList: "TERMINATE,CANCEL"
      # Enables Kafka for notifications
      kafkaEnabledForNotifications: "true"
      # Enables cache for terminated session history
      terminatedSessionHistoryCacheEnabled: "false"
      # Support for original beat in timing
      supportOriginalBeat: "false"
      # Interval for wallet read retries in milliseconds
      walletReadRetryInterval: "100"
      # Number of retries for wallet reads
      walletReadRetryCount: "10"
      # Considers offer priority during alteration agreement evaluation
      useOfferPriorityDuringAlterationAgreementEvaluation: "false"
      # Specifies whether debit session checking is disabled. Set to "true" to disable debit session checking.
      debitSessionCheckDisabled: "false"
      # Interval (in seconds) for randomization of usage validity. A value of "0" indicates no randomization.
      randomizationIntervalForUsageValidity: "0"
      # Controls whether current loan amounts are populated during reference (ref) operations. Set to "false" to disable this feature.
      populateCurrentLoanAmountsOnRef: "true"
      # Saves non-counter grants during ongoing sessions
      saveNonCounterGrantDuringOngoingSession: "false"
      # Specifies whether to skip failed balance updates upon credit ceiling breach. Set to "true" to skip these updates.
      skipFailBalanceUpdatesOnCreditCeilingBreach: "false"
      # Indicates whether reservation over impact is checked. Set to "true" to enable reservation over impact checking.
      checkReservationOverImpact: "false"
      # Time (in seconds) for cycle forward renew. A value of "0" indicates no cycle forward renew time.
      cycleForwardRenewTimeInSecond: "0"
      # List of excluded events for debit refund sessions.
      excludedEventsForDebitRefundSessions: ""
      # Enables cleanup of transaction locks
      cleanupTransactionLockEnabled: "false"
      # Batch size for transaction lock cleanup
      transactionLockCleanupBatchSize: "200"
      # Interval for transaction lock cleanup in milliseconds
      transactionLockCleanupInterval: "300000"
      # Specifies whether FUI (First Usage Initialization) is enabled for initiate operations. Set to "true" to enable FUI for initiate.
      enableFuiForInitiate: "false"
      # Replicates first usage validity initialization event
      replicateFirstUsageValidityInitEvent: "false"
      # Specifies whether currency balances are aggregated for debit units. Set to "false" to disable aggregation.
      aggregateCurrencyBalanceForDebitUnit: "true"
      # Specifies whether non-currency balances are aggregated for debit units. Set to "true" to enable aggregation.
      aggregateNonCurrencyBalanceForDebitUnit: "false"
      # Controls whether session cleanup for SY (Service Logic) is enabled. Set to "true" to enable session cleanup for SY.
      enableSySessionCleanUp: "false"
      checkUsedUnitsAfterFUI: "false"
      enableRatedEventsAggregationForMsccRequest: "false"
      # Controls suppression of threshold breach notifications when multiple threshold breach happen to generate an aggregated one
      suppressMultipleThresholdBreachNotification: "false"
      disableFederationInterceptor: "false"
      # Controls whether corresponding PCF/PCRF feature has been enabled to send subscription ids
      subscriptionIdOnStrEnabled: "false"
      grantRenewalDuringAuthorization: "false"
      rolloverConsumptionRule: "NONE"

      weblogic:
         # JMS module name
         jmsmodule: ECE
         # Subdeployment name for the queue
         subdeployment: ECEQueue
   # Configurations for customer groups
   customerGroupConfigurations:
      # Each dash (-) defines a separate customer group configuration
      # Name of the customer group
      - name:
        # Configuration for preferred clusters for this group
        clusterPreference:
          # Priority level for the first preferred cluster
          - priority: "1"
            # List of routing gateways associated with the cluster (likely empty if not used)
            routingGatewayList: ""
            # Name of the first preferred cluster
            name: "BRM"
          # Priority level for the second preferred cluster
          - priority: "2"
            # List of routing gateways associated with the cluster (likely empty if not used)
            routingGatewayList: ""
            # Name of the second preferred cluster
            name: "BRM2"
      # Same configurations as for the above customer group
      - name:
        clusterPreference:
          - priority: "2"
            routingGatewayList: ""
            name: "BRM"
          - priority: "1"
            routingGatewayList: ""
            name: "BRM2"
   # Configuration for monitoring sites
   siteConfigurations:
      # Name of the monitoring site
      - name: "BRM"
        # Configuration for JMX monitoring agents within this site
        monitorAgentJmxConfigurations:
          # Name of the first monitoring agent
          - name: "monitoringagent1"
            # Hostname or IP address of the monitoring agent
            host:
            # JMX port used by the monitoring agent
            jmxPort:
            # Flag to disable monitoring for this agent
            disableMonitor:
          # Similar configurations as above
          - name: "monitoringagent2"
            host:
            jmxPort:
            disableMonitor:
      # Same configuration like above
      - name: "BRM2"
        monitorAgentJmxConfigurations:
          - name: "monitoringagent1"
            host:
            jmxPort:
            disableMonitor:
          - name: "monitoringagent2"
            host:
            jmxPort:
            disableMonitor:
   # This section configures rated event publishers.
   ratedEventPublishers:
     #clusterName determines site where ref pod is running.
     -  clusterName: "BRM"
        # This property defines the name of the NoSQL connection used by the publisher.
        noSQLConnectionName: "noSQLConnection"
        # This property sets the thread pool size for the publisher.
        threadPoolSize: "4"
   itemAssignmentConfig:
      # Flag indicating whether item assignment is enabled
      itemAssignmentEnabled: "true"
      delayToleranceIntervalInDays: "0"
      # Maximum count of POIDs (point of identification) for persistence safety
      poidPersistenceSafeCount: "12000"
      # Configuration for different POID schemas and their associated quantities
      poidIdConfigurations:
        - schemaName: "1"
          # Maximum quantity of POIDs allowed for schema 1
          poidQuantity: "2000000"
   # Configuration for simple file-based rated event publisher
   simpleFileBasedRatedEventPublisher:
     # Directory where target files are stored
      targetFileDirectory: "../"
   errorHandler:
      # Maximum number of system exceptions with detailed logging allowed per second
      maxNumberSystemExceptionsWithDetailedLoggingPerSecond: "10"
      # Maximum number of system exceptions with detailed logging allowed per minute
      maxNumberSystemExceptionsWithDetailedLoggingPerMinute: "100"
      # Maximum number of system exceptions with detailed logging allowed per hour
      maxNumberSystemExceptionsWithDetailedLoggingPerHour: "300"
   notification:
      # Notification modes for various events
      # "NONE" mode indicates no notification will be sent for the corresponding event
      # "ASYNCHRONOUS" mode implies that notifications will be processed independently and asynchronously.
      # Asynchronous notification processing implies that the notification system does not block or wait for the notification process to complete before continuing with other tasks.
      creditCeilingBreachNotificationMode: "NONE"
      creditFloorBreachNotificationMode: "NONE"
      thresholdBreachNotificationMode: "NONE"
      topUpNotificationMode: "NONE"
      rarNotificationMode: "NONE"
      externalTopUpNotificationMode: "NONE"
      billingNotificationMode: "NONE"
      adviceOfChargeNotificationMode: "NONE"
      replenishPoidIdNotificationMode: "ASYNCHRONOUS"
      lifeCycleTransitionNotificationMode: "NONE"
      firstUsageValidityInitNotificationMode: "NONE"
      offeringUsageValidityInitNotificationMode: "ASYNCHRONOUS"
      spendingLimitNotificationMode: "NONE"
      aggregatedSpendingLimitNotificationMode: "NONE"
      subscriberPreferenceUpdateNotificationMode: "NONE"
      rerateJobCreateNotificationMode: "ASYNCHRONOUS"
      customEventNotificationMode: "NONE"
      enrichBalanceQueryResponseMode: "NONE"
      eventListForInternalExternalPublish: "OFFERING_VALIDITY_INITIALIZATION_EVENT,EXTERNAL_TOP_UP_NOTIFICATION_EVENT"
      kafkaPartitionForInternalExternal: "0"
      loanGrantNotificationMode: "NONE"
      automaticTopUpTriggerNotificationMode: "NONE"
      subscriptionCycleForwardMode: "NONE"
      customBrmOpCodeEventNotificationMode: "NONE"
      abortSessionRequestNotificationMode: "ASYNCHRONOUS"
      userDisconnectNotificationMode: "NONE"
      # List of events for ECE external topic
      eventListForECEExternalTopic: ""
      # Notification enrichment configuration list
      notificationEnrichmentConfigList:
            enrichName: "subscriberPreferences"
            enrichValue: ""
   diameterGatewayPeerConfigurations:
      # Name of the Diameter gateway peer
      - peerName: "peer1"
        # Configuration for alternate Diameter peers
        diameterGatewayAlternatePeerConfigurations:
          - alternatePeerName: "alternatePeer1"
          - alternatePeerName: "alternatePeer2"
   # Expiration configuration for various types of records
   expirationConfiguration:
         # Set the retention interval for expired audit records to 45 days.
         expiredAuditRetentionIntervalInDays: "45"
         # Set the retention interval for expired purchased charges to 20 days.
         expiredPurchasedChargesRetentionIntervalInDays: "20"
         # Set the retention interval for expired purchased alterations to 30 days.
         expiredPurchasedAlterationRetentionIntervalInDays: "30"
         # Set the retention interval for expired rating profiles to 40 days.
         expiredRatingProfileRetentionIntervalInDays: "40"
         # Set the default retention interval for expired items to 50 days.
         defaultExpirationRetentionIntervalInDays: "50"
         # Set the default retention interval for expired balance items to 60 days.
         defaultExpiredBalanceItemRetentionIntervalInDays: "60"
         # Set the default retention interval for expired RBundle history to 30 days.
         defaultExpiredRBundleHistoryRetentionIntervalInDays: "30"
         # Set the retention interval for expired ASO (Account State Object) records to -1, indicating indefinite retention.
         expiredAsoRetentionIntervalInDays: "-1"
         # Debit refund session cleanup interval (-1 for indefinite retention)
         debitRefundSessionCleanUpIntervalInDays: "-1"
   extensions:
      # Extension executed before rating.
      preRatingExtension: ""
      # Extension executed during rating.
      ratingExtension: ""
      # Extension executed after rating.
      postRatingExtension: ""
      # Extension executed after charging.
      postChargingExtension: ""
      # Extension executed for Diameter GY (Gy Interface) interactions
      diameterGyExtension: ""
      # Extension executed for RADIUS authentication.
      radiusAuthExtension: ""
      # Extension executed for RADIUS accounting.
      radiusAccountingExtension: ""
      # Extension executed after an update operation.
      postUpdateExtension: ""
      ocsBypassExtension: ""
      # Extension executed for HTTP interactions.
      httpExtension: ""
      # Extension executed for BRM (Billing and Revenue Management) Gateway
      brmGwExtension: ""
      # Extension executed before mid-session rating
      preRatingMidSessionExtension: ""
      # Extension executed for Diameter SY (Service Logic) interactions
      diameterSyExtension: ""
      # Extension executed after mid-session rating
      postRatingMidSessionExtension: ""
      httpSyExtension: ""
   brmCdrPlugins:
     # Configuration for BRM CDR plugins.
     brmCdrPluginConfigurationList:
        # Configuration for BRM CDR Plugin 1.
        - brmCdrPluginConfiguration:
            # Unique name for the BRM CDR Plugin.
            name: "brmCdrPlugin1"
            # Temporary directory path for processing.
            tempDirectoryPath: "/tmp/tmp"
            # Directory path where processed files are moved.
            doneDirectoryPath: "/home/charging/rel_input/"
            # Directory path for storing invalid rated events.
            invalidRatedEventDirectoryPath: "/tmp/invalid"
            # Extension for files after processing is completed.
            doneFileExtension: ".out"
            # Extension for header files.
            headerFileExtension: ".out"
            # Extension for data files.
            dataFileExtension: ".blk"
            # Extension for control files.
            ctlFileExtension: ".ctl"
            # Directory path for header files.
            headerFileDirectoryPath: "/home/charging/rel_input/"
            # Directory path for data files.
            dataFileDirectoryPath: "/home/charging/rel_input/"
            # Flag to enable/disable processing of invalid rated events.
            enableInvalidRatedEvents: "false"
            # Character set for SQL Loader.
            sqlLoaderCharacterSet: "UTF8"
            # Partition set for prepaid CDRs
            prepaidPartitionSet: "0"
   cdrFormatterPlugins:
     # Configuration for CDR Formatter plugins.
     cdrFormatterPluginConfigurationList:
       # Configuration for CDR Formatter Plugin 1.
       cdrFormatterPluginConfiguration:
         # Unique name for the CDR Formatter Plugin.
         name: "cdrFormatterPlugin1"
         # Temporary directory path for processing.
         tempDirectoryPath: "/tmp/tmp"
         # Directory path where processed files are moved.
         doneDirectoryPath: "/home/charging/cdr_input"
         # Extension for files after processing is completed.
         doneFileExtension: ".out"
         # Flag to enable/disable Kafka integration.
         enableKafkaIntegration: "false"
         # Flag to enable/disable disk persistence.
         enableDiskPersistence: "true"
         # Maximum count of CDRs processed per batch.
         maxCdrCount: "20000"
         # String indicating the cause for closing stale sessions.
         staleSessionCauseForRecordClosingString: "PARTIAL_RECORD"
         # Flag to enable/disable cleanup of stale session custom fields.
         enableStaleSessionCleanupCustomField: "false"
   nfProfileConfigurations:
     # Mapping of instance IDs.
     instanceIdMapping: ""
     # List of NF (Network Function) profile configurations.
     nfProfileConfigurationList:
        # Configuration for NF Profile "httpGateway1".
        - name: "httpGateway1"
          # JSON request payload for the NF Profile
          # API version used in the NRF URI
          nrfApiVersionInUri: "v1"
          # Name of the cluster associated with the NF Profile
          clusterName: "BRM"
          # URL for NRF (Network Repository Function) REST endpoint.
          nrfRestEndPointUrl: ""
          # URLs for secondary sites' NRF REST endpoints
          nrfSecondarySiteRestEndPointUrls: ""
          # Flag indicating whether HTTP/2 is enabled.
          nrfHttp2Enable: "true"
          # Type of NF (e.g., CHF, etc.).
          nfType: "CHF"
          # Fully qualified domain name.
          fqdn: ""
          # IPv4 addresses.
          ipv4Addresses: ""
          # Capacity of the NF.
          capacity: "0"
          # Load on the NF.
          load: "0"
          # Start of range for SUPI (Subscription Permanent Identifier).
          supiRangeListStart: "10000"
          # End of range for SUPI.
          supiRangeListEnd: "10008"
          # Pattern for SUPI range list.
          supiRangeListPattern: "^nai-450081.+@.+org$"
          # Start of range for GPSI (Global Subscription Permanent Identifier).
          gpsiRangeListStart: "10000"
          # End of range for GPSI.
          gpsiRangeListEnd: "10008"
          # Pattern for GPSI range list.
          gpsiRangeListPattern: "^extid-.+@oracle1.com$"
          # Start of range for PLMN (Public Land Mobile Network).
          plmnRangeListStart: "100000"
          # End of range for PLMN.
          plmnRangeListEnd: "333333"
          # Pattern for PLMN range list.
          plmnRangeListPattern: ""
          # Status of the NF.
          nfStatus: "REGISTERED"
          # Heartbeat timer.
          heartBeatTimer: ""
          # MCC (Mobile Country Code) list for PLMN.
          plmnListMcc: ""
          # MNC (Mobile Network Code) list for PLMN.
          plmnListMnc: ""
          # SD (Serving Data) list for SNSSAI (Service Network Slice Selection Assistance Information).
          snssaisSdl: ""
          # SST (Slice/Service Type) list for SNSSAI.
          snssaisSst: ""
          # MCC list for per PLMN SNSSAI.
          perPlmnSnssaiListPlmnIdMcc: ""
          # MNC list for per PLMN SNSSAI.
          perPlmnSnssaiListPlmnIdMnc: ""
          # SST list for per PLMN SNSSAI.
          perPlmnSnssaiListSst: ""
          # SD list for per PLMN SNSSAI.
          perPlmnSnssaiListSd: ""
          # NSI (Network Slice Instance) list.
          nsiList: ""
          # FQDN for inter-PLMN communication.
          interPlmnFqdn: ""
          # IPv6 addresses.
          ipv6Addresses: ""
          # Allowed MCCs (Mobile Country Codes).
          allowedPlmnsMcc: ""
          # Allowed MNCs (Mobile Network Codes).
          allowedPlmnsMnc: ""
          # Allowed NF types.
          allowedNfTypes: ""
          # Allowed NF domains.
          allowedNfDomains: ""
          # Allowed SSTs (Slice/Service Types).
          allowedNssaisSst: ""
          # Allowed SDs (Serving Data).
          allowedNssaisSd: ""
          # Locality information.
          locality: ""
          # Custom information.
          customInfo: ""
          # Recovery time.
          recoveryTime: ""
          # Flag indicating NF service persistence.
          nfServicePersistence: ""
          # Flag indicating NF profile changes support.
          nfProfileChangesSupportInd: ""
          # Flag indicating NF profile changes
          nfProfileChangesInd: ""
          # Notification type for default notification subscriptions.
          defaultNotificationSubscriptionsNotificationType: ""
          # Callback URI for default notification subscriptions.
          defaultNotificationSubscriptionsCallbackUri: ""
          # N1 message class for default notification subscriptions.
          defaultNotificationSubscriptionsN1MessageClass: ""
          # N2 information class for default notification subscriptions.
          defaultNotificationSubscriptionsN2InformationClass: ""
          # Name of the associated HTTP gateway.
          httpGatewayName: "httpgateway1"
          # Primary NF instance (UUID).
          primaryChfInstance: ""
          # Secondary NF instance (UUID).
          secondaryChfInstance: ""

   nfServiceConfigurations:
    # List of NF (Network Function) service configurations.
    nfServiceConfigurationList:
         # Configuration for NF Service "chf1".
         - name: "chf1"
           # clusterName determines site where ref pod is running.
           clusterName: "BRM"
           # Unique ID for the service instance.
           serviceInstanceId: "chf1"
           # Name of the service.
           serviceName: "nchf-convergedcharging"
           # API version in URI.
           apiVersionInUri: "v1"
           # Full API version.
           apiFullVersion: "1.R15.1.0"
           # Expiry timestamp.
           expiry: "2020-12-01T18:55:08.871Z"
           # Communication scheme (e.g., HTTP, HTTPS).
           scheme: "http"
           # Status of the NF service.
           nfServiceStatus: "REGISTERED"
           # IPv4 address of the NF service.
           ipv4Address: ""
           # Transport protocol (e.g., TCP, UDP).
           transport: "TCP"
           # Port for communication.
           port: ""
           # Capacity of the NF service.
           capacity: "50"
           # Load on the NF service.
           load: "5"
           # Priority of the NF service.
           priority: "1"
           # FQDN for inter-PLMN communication.
           interPlmnFqdn: ""
           # IPv6 address of the NF service.
           ipv6Address: ""
           # Notification type for default notification subscriptions.
           defaultNotificationSubscriptionsNotificationType: ""
           # Callback URI for default notification subscriptions.
           defaultNotificationSubscriptionsCallbackUri: ""
           # N1 message class for default notification subscriptions.
           defaultNotificationSubscriptionsN1MessageClass: ""
           # N2 information class for default notification subscriptions.
           defaultNotificationSubscriptionsN2InformationClass: ""
           # Allowed MCCs (Mobile Country Codes).
           allowedPlmnsMcc: ""
           # Allowed MNCs (Mobile Network Codes).
           allowedPlmnsMnc: ""
           # Allowed NF types.
           allowedNfTypes: ""
           # Allowed NF domains.
           allowedNfDomains: ""
           # Allowed SSTs (Slice/Service Types).
           allowedNssaisSst: ""
           # Allowed SDs (Serving Data).
           allowedNssaisSd: ""
           # Recovery time.
           recoveryTime: ""
           # Supported features.
           supportedFeatures: ""
           # Primary CHF service instance.
           primaryChfServiceInstance: ""
           # Secondary CHF service instance.
           secondaryChfServiceInstance: ""
           # Fully qualified domain name.
           fqdn: ""
           # API Prefix
           apiPrefix: ""
           # Name of the associated HTTP gateway.
           httpGatewayName: "httpgateway1"
   cachePersistenceConfigurations:
      # List of cache persistence configurations.
      cachePersistenceConfigurationList:
        # clusterName determines site where ref pod is running.
        -  clusterName: "BRM"
           # Type of persistence store.
           persistenceStoreType: "OracleDB"
           # Name of the persistence connection.
           persistenceConnectionName: "oraclePersistence1"
           # Size of the thread pool for reloading.
           reloadThreadPoolSize: "10"
           # Flag indicating whether to load configuration from persistence.
           configLoadFromPersistence: "true"
           # Flag indicating whether to load pricing from persistence.
           pricingLoadFromPersistence: "true"
           # Flag indicating whether to load customer data from persistence.
           customerLoadFromPersistence: "true"
           # Flag indicating whether to recover partition loss from persistence
           partitionLossRecoverFromPersistence: "true"
           # Size of the thread pool for write behind.
           writeBehindThreadPoolSize: "1"
   connectionConfigurations:
         # Configuration for Oracle Persistence Connection Configurations.
         OraclePersistenceConnectionConfigurations:
            #clusterName determines site where ref pod is running.
            - clusterName: "BRM"
              # Schema number
              schemaNumber: "1"
              # Name of the connection
              name: "oraclePersistence1"
              # Username for DB system DBA.
              dbSysDBAUser: "sys"
              # Role for DB system DBA.
              dbSysDBARole: "sysdba"
              # Username for the connection.
              userName: "ece"
              # Hostname of the database.
              hostName: "${DBHOST}"
              # Port number of the database.
              port: "1521"
              # SID (System Identifier) of the database.
              sid: ""
              # Service name of the database.
              service: "${DBSERVICE}"
              # Tablespace for ECE.
              tablespace: "ECE_DATA"
              # Temporary tablespace for ECE.
              temptablespace: "ECE_TEMP"
              # Tablespace for CDR (Call Detail Record) store.
              cdrstoretablespace: "ECECDR_DATA"
              # Tablespace for CDR index.
              cdrstoreindexspace: "ECECDR_IND"
              # JDBC URL for the connection.
              jdbcUrl: "jdbc:oracle:thin:@${DBHOST}:1521/${DBSERVICE}"
              # Number of retry attempts.
              retryCount: "3"
              # Interval between retry attempts.
              retryInterval: "1"
              # Maximum size of the statement cache.
              maxStmtCacheSize: "100"
              # Timeout for connection wait.
              connectionWaitTimeout: "300"
              # Interval for connection check timeout.
              timeoutConnectionCheckInterval: "300"
              # Timeout for inactive connections.
              inactiveConnectionTimeout: "300"
              # Timeout for database connections.
              databaseConnectionTimeout: "600"
              # Initial size of the persistence pool.
              persistenceInitialPoolSize: "4"
              # Minimum size of the persistence pool.
              persistenceMinPoolSize: "4"
              # Maximum size of the persistence pool.
              persistenceMaxPoolSize: "12"
              # Initial size of the reload pool.
              reloadInitialPoolSize: "0"
              # Minimum size of the reload pool.
              reloadMinPoolSize: "0"
              # Maximum size of the reload pool.
              reloadMaxPoolSize: "20"
              ratedEventInitialPoolSize: "0"
              ratedEventMinPoolSize: "1"
              ratedEventMaxPoolSize: "1"
              # Initial size of the rated event formatter pool.
              ratedEventFormatterInitialPoolSize: "6"
              # Minimum size of the rated event formatter pool.
              ratedEventFormatterMinPoolSize: "6"
              # Maximum size of the rated event formatter pool.
              ratedEventFormatterMaxPoolSize: "6"
              # Partition time for rated event table.
              ratedEventTablePartitionByMinute: "5"
              # Initial storage size for rated event table.
              ratedEventTableStorageInitial: "104857600"
              # Next storage size for rated event table.
              ratedEventTableStorageNext: "104857600"
              # Number of subpartitions for rated event table.
              ratedEventTableSubpartitions: "32"
              # Flag indicating whether DB SSL is enabled.
              dbSSLEnabled: "false"
              # TLS version used for database connection
              tlsVersion: "1.3"
              # Type of database SSL configuration (e.g., "twoway" for mutual SSL)
              dbSSLType: "oneway"
              # Distinguished Name (DN) of the server SSL certificate for database connection
              sslServerCertDN: "DC=local,DC=oracle,CN=pindb"
              # Location of the trust store.
              trustStoreLocation: "/home/charging/ext/ece_ssl_db_wallet/schema1/cwallet.sso"
              # Type of trust store.
              trustStoreType: "SSO"
              # Location of the wallet.
              walletLocation: "/home/charging/wallet/ecewallet/"
              # Number of partitions for CDR store.
              cdrStorePartitionCount: "32"
              # Query timeout.
              queryTimeout: "5"
              # Location of Oracle files used for database connections or configurations (e.g., Oracle Database Resource Manager files)
              oraFilesLocation: "/home/charging/ext/ora_files/ece/"
              # Name of the external secret containing SSL Trust store, if present
              extPersistenceDBSSLWalletSecret:
         NoSQLConnectionConfigurations:
            # Configuration for NoSQL Connection Configurations.
            # clusterName determines site where ref pod is running.
            - clusterName: "BRM"
              # Name of the connection.
              name: "noSQLConnection"
              # Data store connection details.
              dataStoreConnection: ""
              dataStoreConnectionHost: ""
              dataStoreConnectionAlias: ""
              dataStoreConnectionIP: ""
              # Name of the data store.
              dataStoreName: "kvstore"
              # Timeout for NoSQL operations.
              noSQLTimeout: "5"
              # Number of retry attempts.
              retryCount: "5"
              # Number of partitions for CDR store.
              cdrStorePartitionCount: "32"
         BRMConnectionConfiguration:
            # Configuration for BRM Connection.
            name: "brmConnection"
            # Hostname of the BRM.
            hostName: "cm"
            # Protocol used for connection.
            protocol: "pcp"
            # Login name for authentication.
            loginName: "root.0.0.0.1"
            # Port number for CM (Connection Manager).
            cmPort: "11960"
            # Login type.
            loginType: "1"
            # Number of connections.
            numberOfConnections: "10"
            # Flag indicating SSL enablement.
            sslEnabled: "1"
            # Failover connection URLs
            failOverConnectionUrls: ""
            # Location of ECE wallet.
            eceWalletLocation: "/home/charging/wallet/ecewallet/"
            # Location of BRM wallet.
            brmwallet: "/home/charging/wallet/brmwallet/client/cwallet.sso"
   brsConfigurations:
      # Configuration for BRS (Billing and Revenue System).
      brsConfigurationList:
         # Acceptable pending count.
         - acceptablePendingCount: "10"
           # Batch size for high priority requests.
           highPriorityBatchSize: "2"
           # Timeout for high priority batch.
           highPriorityBatchTimeout: "30"
           # Size of thread pool for high priority requests.
           highPriorityThreadPoolSize: "-1"
           # Name of the configuration.
           name: "default"
           # Flag indicating overload protection.
           overloadProtection: "false"
           # Threshold percentage for pending request heap usage.
           pendingRequestHeapUsageThresholdPercentage: "30"
           # Batch size for regular priority requests.
           regularPriorityBatchSize: "1"
           # Timeout for regular priority batch.
           regularPriorityBatchTimeout: "50"
           # Size of thread pool for regular priority requests.
           regularPriorityThreadPoolSize: "200"
           # Reporting window size.
           reportingWindowSize: "30"
           # Timeout for response.
           responseTimeout: "10"
           # Threshold latency.
           thresholdLatency: "10"
           # Flag indicating throttle processing per customer.
           throttleProcessingPerCustomer: "false"
           # Maximum size of HTTP connection pool.
           httpConnectionPoolMax: "500"
           # Maximum time to wait for update response.
           updateResponseMaxWaitTime: "10000"
           # Timeout (in milliseconds) for health checks performed on the routing gateway.
           routingGatewayHealthCheckTimeout: "2000"
           # Interval (in milliseconds) between health check attempts for the routing gateway.
           routingGatewayHealthCheckInterval: "20000"
           # Indicates whether to skip preferred site routing in an active-active setup. Set to "true" to skip preferred site routing.
           skipActiveActivePreferredSiteRouting: "false"
           # The additional number of milliseconds that BRS will allow before evicting/aborting requests that have not yet been sent to the ECE Server
           ingressRequestTimeoutMs: "3000"
           # The maximum number of times BRS will retry processing a request that has not expired
           requestMaxRetry: "3"
           # The additional number of milliseconds that BRS will wait between retries
           requestRetryWaitTimeMs: "5"
   kafkaConfigurations:
      # Configuration for Kafka.
      kafkaConfigurationList:
         # Name of the Kafka configuration.
         - name: "BRM"
           # Hostname of Kafka.
           hostname: "bootstrap-clstr-uuvnb7njgnqqj9p0.kafka.eu-frankfurt-1.oci.oraclecloud.com:9093"
           # Topic name
           topicName: "ECENotifications"
           # Suspense topic name.
           suspenseTopicName: "ECESuspenseQueue"
           # Failure topic name.
           failureTopicName: "EceFailureQueue"
           # Overage topic name.
           overageTopicName: "ECEOverageTopicName"
           # Number of partitions.
           partitions: "200"
           # Number of failure partitions.
           failurePartitions: "200"
           # Flag indicating external topic enablement.
           externalTopicEnabled: "false"
           # External topic name.
           externalTopicName: "EceExtNotifications"
           # Number of external partitions.
           externalPartitions: "15"
           # Location of wallet.
           walletLocation: "/home/charging/wallet/ecewallet/"
           # Kafka Radius topic name.
           kafkaRGWTopicName: "ECERadiusNotifications"
           # Reconnection interval for Kafka producer.
           kafkaProducerReconnectionInterval: "2000"
           # Maximum reconnection time for Kafka producer.
           kafkaProducerReconnectionMax: "30000"
           # Reconnection interval for Kafka DGW.
           kafkaDGWReconnectionInterval: "2000"
           # Maximum reconnection time for Kafka DGW.
           kafkaDGWReconnectionMax: "30000"
           # Reconnection interval for Kafka BRM.
           kafkaBRMReconnectionInterval: "2000"
           # Maximum reconnection time for Kafka BRM.
           kafkaBRMReconnectionMax: "30000"
           # Reconnection interval for Kafka HTTP.
           kafkaHTTPReconnectionInterval: "2000"
           # Maximum reconnection time for Kafka HTTP.
           kafkaHTTPReconnectionMax: "30000"
           # Indicates whether failed requests should be persisted to a Kafka topic (set to "true" to enable)
           persistFailedRequestsToKafkaTopic: "false"
           # Topic name for Kafka CDR.
           kafkaCDRTopicName: "ChfChargingRecords"
           # Number of partitions for Kafka CDR.
           kafkaCDRPartitions: "1"
           # Flag indicating SSL enablement for Kafka CDR.
           kafkaSSLEnabled: "true"
           #securityProtocol: "SASL_SSL"
           # Location of trust store for Kafka CDR.
           kafkaTrustStoreLocation: "kafka.jks"
           # Name of the external secret containing server kafka SSL Key store, if present
           extKafkaTrustStoreSecret: "ece-kafka-secret"
           # Compression type for Kafka CDR.
           kafkaCDRCompressionType: "gzip"
           # Reconnection interval for Kafka RGW.
           kafkaRGWReconnectionIntervalMillis: "2000"
           # Maximum reconnection time for Kafka RGW.
           kafkaRGWReconnectionMaxMillis: "30000"

migration:
   loader:
      # Specifies the directory where pricing data files are located.
      pricingDataDirectory: "/home/charging/opt/ECE/oceceserver/sample_data/pricing_data"
      # Points to the directory containing configuration objects for end-to-end specifications.
      configObjectsDataDirectory: "/home/charging/opt/ECE/oceceserver/sample_data/config_data/specifications/ece_end2end"
      # File path for the product offering cross-reference XML, mapping product offerings between systems.
      productOfferingCrossRefFilePath: "/home/charging/opt/ECE/oceceserver/sample_data/crossref_data/ProductXRefSample.xml"
      # Directory containing customer data files.
      customerDataDirectory: "/home/charging/opt/ECE/oceceserver/sample_data/customer_data"
      # The pattern used to identify customer XML files within the customer data directory.
      customerXmlPattern: "customer"
      # Number of threads for remote work manager to process tasks concurrently.
      remoteWmThreads: "1"
      # Number of records processed in one batch.
      batchSize: "5000"
      # Number of database connections to use.
      dbConnections: "1"
      # Number of records to fetch from the database in one go.
      dbFetchSize: "5000"
      # Placeholder for the payload configuration file path.
      payloadConfigFilePath: "@PAYLOAD_CONFIG_FILE_PATH@"
      # Indicates whether migration is running in a mode that selectively migrates data.
      selectiveMigrationMode: "false"
      # SQL queries for filtering customers during initial and incremental loads.
      initialCustomerLoadFilterQuery: ""
      incrementalCustomerLoadFilterQuery: ""
      #customerGroupList - values must be separated by Commas - Used only if isFederation is true
      customerGroupList: ""
   # Configurations for connecting to a server to update pricing information.
   pricingUpdater:
      # Hostname of the Pricing Updater service
      hostName: "pdc-service"
      # Port number of the Pricing Updater service
      port: "8001"
      # Username for authentication with the Pricing Updater service
      userName: "weblogic"
      # Connection URL for the Pricing Updater service
      connectionURL: "t3://pdc-service:8001"
      # Retry logic for establishing the connection.
      connectionRetryCount: "1073741823"
      connectionRetrySleepInterval: "10000"
      # Connection factory name used by the Pricing Updater service
      connectionFactory: "JobDispatcher/MyXAQCF"
      # Name of the work item queue used by the Pricing Updater service
      workItemQueueName: "BPA/ECE_WorkItemQueue"
      # Name of the work result queue used by the Pricing Updater service
      workResultQueueName: "JobDispatcher/WORKRESULTDATA_QUEUE"
      # Configuration for the communication protocol and context factory.
      protocol: "t3://"
      initialContextFactory: "weblogic.jndi.WLInitialContextFactory"
      # Timeout for requests in milliseconds
      requestTimeOut: "3000"
      keyStoreLocation: ""
      # Name of the external secret containing server PDC SSL Key store, if present
      extPDCKeyStoreSecret:
      # Flags and locations for generating request specification XMLs.
      requestSpecXMLGenarationEnabled: "false"
      # Location to store generated request specification XML files (if enabled)
      requestSpecXMLGenarationLocation: "../config/generated-request-specifications/"

testtools:
   common:
      # General settings for test execution.
      # Total number of customers to simulate.
      numCustomers: "1000"
      # Starting ID for customer generation.
      startCustomerId: "6500000000"
      # Number of transactional customers.
      numTxCustomers: "100"
      # Starting ID for transactional customers.
      startTxCustomerId: "4900000000"
      # Number of products to simulate.
      numProducts: "1"
      clusterGroup: "BRM-Dev"
   simulators:
      simulatorConfig:
          # Configuration for the ECE invocation simulator.
          name: "ece-invocation"
          # Duration of the simulation
          duration: "30"
          # Target operations per second.
          throughput: "200"
          # Distribution of different types of usage.
          #  - IC (Information Collection): Percentage of Information Collection operations
          #  - IUT (Information Update): Percentage of Information Update operations
          #  - T (Transactions): Percentage of Transaction operations
          #  - P (Policy): Percentage of Policy operations
          usageIC: "20"
          usageIUT: "60"
          usageT: "20"
          usageP: "0"
          # Distribution of traffic types:
          #  - usageTraffic: Percentage of usage-related traffic
          #  - queryTraffic: Percentage of query-related traffic
          #  - policyTraffic: Percentage of policy-related traffic
          usageTraffic: "100"
          queryTraffic: "0"
          policyTraffic: "0"
          # Balance Query Mode: How balance information is queried (SUMMARY, DETAIL)
          # Likely a reference to an index for query mode options
          queryBalance: "0"
          balanceQueryMode: "SUMMARY"
          # Options related to subscriber preferences for queries
          # Likely a reference to an index for preference options
          querySubscriberPreference: "0"
          # Option to enable query authentication (true/false)
          # Likely 0 for disabled, 1 for enabled
          queryAuthentication: "0"
          # Distribution of policy subscription traffic types:
          #  - policySubscriptionTraffic: Percentage of policy subscription traffic
          #  - policySpendingLimitNotificationTraffic: Percentage of spending limit notification traffic
          #  - policySessionTraffic: Percentage of policy session traffic
          policySubscriptionTraffic: "30"
          policySpendingLimitNotificationTraffic: "50"
          policySessionTraffic: "20"
          # Comma-separated list of policy subscriber preferences
          policySubscriberPreferences: "Channel;Language"
          # Comma-separated list of policy counters to track
          policyCounters: "FREE_MIN;USAGE_COUNTER"
          # Percentage of update balance operations
          updateBalance: "50"
          # Percentage of update type create customer operations
          updateTypeCreateCustomer: "20"
          # Percentage of PUI (Personal Unblocking Key) update operations
          updatePui: "30"
          # Percentage of log writes
          writeLogPercentage: "10"
          # Type of product being simulated (e.g., TelcoGsmTelephony)
          productType: "TelcoGsmTelephony"
          # Date and time to start the simulated sessions
          sessionStartDate: "06/02/2020 10:45:00"
          # Number of token units per session
          tokenUnits: "10"
          # Enable Multi Service Control Center (true/false)
          # Likely 0 for disabled, 1 for enabled
          mscc: "false"
          # Option to use condensed period between operations in a session (true/false)
          # Likely 0 for disabled, 1 for enabled
          useCondensedPeriodBetweenOperationsInSession: "false"
          # Percentage of TX (Transaction) traffic
          txTraffic: "0"
          # Delay in seconds before resetting latency tracking
          latencyTrackingResetDelayInSeconds: "10"
      sessionUnitConfig:
           # Number of session units
           sessionUnits: "15"
           # Percentage of operations that belong to sessions
           percentage: "100"
   loader:
         # Loader settings for customer data preparation.
         # Number of customers per batch.
         customerBatchSize: "500"
         # Number of threads for customer data loading.
         customerThreads: "2"
         # Number of credit profiles to consider
         numCreditProfiles: "4"
         # Configuration for subscription and alteration offerings.
         # Number of subscription product offerings
         numSubscriptionProductOfferings: "1"
         # Number of purchased offerings per product
         purchasedOfferingsPerProduct: "1"
         # Calculation method for RUM (Rate Unit of Measure)
         rum: "end - start"
         # Subscription rate graph configuration
         subscriptionGraphs: "#name: m4 [rate:linearRate(0.05/mn),balance_element:&quot;USD&quot;]"
         # System alteration rate graph configuration
         systemAlterationGraphs: "[rate:fixedAlteration(-0.10),balance_element:&quot;USD&quot;]"
         # Number of system alteration offerings
         numSystemAlterationOfferings: "1"
         # Directory containing specification files
         specFilesDirectory: "/home/charging/opt/ECE/oceceserver/sample_data/config_data/specifications/ece_simple"
   customerGenerator:
         # Configuration for generating customer data files.
         # Number of customers per generated file.
         customersPerFile: "500"
         # Starting balance for generated customers.
         balanceAmount: "-100"
         # Element ID for balance (e.g., currency code)
         balanceElementId: "840"
         #  Product offering for customers
         productOfferings: "Milestone4Sample4ChargeOffering"
         # Alteration offering for customers
         alterationOfferings: "AO2_PercentDisc"
         # Distribution offering for customers
         distributionOfferings: "CS50%Sharing"
         # Flag indicating whether alteration agreements are shared
         shareAlterationAgreements: "true"
         # Type of product/service offered
         productTypes: "/service/telco/gsm/telephony"
         # Directory to save generated customer data files
         destinationDir: "."
         # Number of balance items per balance
         balanceItemsPerBalance: "1"
         # Number of aliases per product
         aliasesPerProduct: "1"
         # Product rating profile configuration
         productRatingProfiles: "PFAF"
         # Customer rating profile configuration
         customerRatingProfiles: "CFAF"
         # Number of audit revisions
         numAuditRevisions: "0"
         # Flag indicating whether to validate generated XML files
         validateXml: "true"
         # Flag indicating whether generation is template-driven
         isTemplateDriven: "false"
         # Path to customer template file
         customerTemplateFile: "../sample_data/customer_data/customer_templates/cust_template_simple.xml"
         # Path to customer template file for sharing transactions
         txCustomerTemplateFile: "../sample_data/customer_data/customer_templates/cust_template_sharing.xml"
         # Flag indicating whether multiple balances are used
         multipleBalances: "true"
         # Additional attributes for customers and products.
         # Additional attributes for customers
         extendedCustomerAttributes: "ACCOUNT_TAG: GoldCustomer"
         # Additional attributes for products
         extendedProductAttributes: "SERVICE_ID: Tel0001,TELCO_INFO.MSISDN: 1231231234"

subscriberTrace:
   # File path where the subscriber trace configuration is stored. It indicates the XML file location that contains settings for subscriber tracing.
   filePath: "/home/charging/config/subscriber-trace.xml"
   # Specifies the maximum number of individual subscribers that the system will track simultaneously in its logs
   logMaxSubscribers: "100"
   # Defines the maximum number of sessions per subscriber that can be logged concurrently.
   logMaxSubscriberSessions: "24"
   # Indicates the duration after which the logged data for a subscriber is considered old and can be purged from the system.
   logExpiryWaitTime: "1"
   # Specifies the frequency (in days) at which the system will perform a cleanup operation to remove expired logs based on the logExpiryWaitTime
   logCleanupInterval: "2"
   # Sets the granularity of the logs captured for subscriber tracing.
   # A level of “DEBUG” is the most detailed, capturing a comprehensive range of information about each subscriber session.
   logLevel: "DEBUG"
   # Specifying a list of subscribers to be explicitly traced.
   subscriberList: ""
log4j2:
   logger:
      # Set to "ERROR" means focusing on logging error-level events and higher.
      # Set to "INFO" means enabling logging of informational messages and higher levels of severity.
      # Set to "DEBUG" means enabling the most detailed logging, including debug-level messages.
      # Set to "WARN" means Logging warning messages and higher levels of severity.
      appconfiguration: "ERROR"
      balance: "ERROR"
      brs: "ERROR"
      brsDiagnostics: "INFO"
      diametergatewayCdrtrace: "OFF"
      ecsCdrtrace: "OFF"
      config: "ERROR"
      customer: "ERROR"
      dsl: "ERROR"
      ecegatewayDiameterFramework: "INFO"
      ecegatewayDiameterGy: "INFO"
      ecegatewayDiameterLauncher: "INFO"
      ecegatewayDiameterSh: "INFO"
      ecegatewayDiameterSy: "INFO"
      diameterTekelec: "ERROR"
      camiant: "INFO"
      camiantDiameterApps: "INFO"
      ecegatewayRadius: "INFO"
      ecegatewayHttpServer: "INFO"
      ecegatewayCdr: "INFO"
      cdrFormatter: "INFO"
      cdrFormatterPlugin: "INFO"
      extensions: "INFO"
      federationClient: "ERROR"
      federationInterceptor: "ERROR"
      identity: "ERROR"
      brmgateway: "ERROR"
      emgateway: "ERROR"
      kafka: "ERROR"
      messagesFramework: "ERROR"
      messagesManagement: "ERROR"
      messagesQuery: "ERROR"
      messagesUpdate: "ERROR"
      messagesUsage: "ERROR"
      migrationConfig: "INFO"
      migrationCrossref: "INFO"
      customerLoader: "INFO"
      customerUpdater: "ERROR"
      pricingLoader: "INFO"
      pricingUpdater: "INFO"
      notification: "ERROR"
      requestenrichment: "ERROR"
      orchestrationCommon: "ERROR"
      orchestrationFramework: "ERROR"
      orchestrationManagement: "ERROR"
      orchestrationQuery: "ERROR"
      orchestrationSubscription: "ERROR"
      orchestrationUpdate: "ERROR"
      orchestrationUsage: "ERROR"
      orchestrationPolicy: "ERROR"
      pdcspecgen: "ERROR"
      pricing: "ERROR"
      processorFramework: "WARN"
      processorManagement: "ERROR"
      processorUpdate: "ERROR"
      processorUsage: "ERROR"
      product: "ERROR"
      ratedeventDao: "ERROR"
      ratedeventFormatter: "INFO"
      ratedeventFormatterPlugin: "INFO"
      ratedeventPurgeratedevent: "INFO"
      ratedeventService: "INFO"
      ratedeventtrace: "ERROR"
      rating: "ERROR"
      ratingCharge: "ERROR"
      ratingAlteration: "ERROR"
      ratingDistribution: "ERROR"
      server: "INFO"
      session: "ERROR"
      sharingagreement: "ERROR"
      statemanager: "ERROR"
      subscribertraceConfiguration: "INFO"
      subscribertraceLog: "INFO"
      monitorFramework: "ERROR"
      monitorAgent: "ERROR"
      monitorConfiguration: "ERROR"
      monitorUtils: "ERROR"
      monitorSummary: "INFO"
      monitorAlert: "INFO"
      cachepersistenceDao: "INFO"
      cachepersistenceReload: "INFO"
      cachepersistencePersist: "INFO"
      cachepersistenceData: "INFO"
      cachepersistenceUtil: "INFO"
      toolsLpr: "INFO"
      tools: "INFO"
      highavailability2: "INFO"
      transports: "ERROR"
      util: "ERROR"
      utilCacheMigration: "INFO"
      utilEvictingQueue: "ERROR"
      Coherence: "ERROR"
      springframework: "ERROR"
      brmRatedeventmanager: "ERROR"
      brmRatedeventmanagerDiagnostic: "ERROR"
      root: "ERROR"

# eceproperties: Configuration for Elastic Charging Engine (ECE) file locations.
eceproperties:
   # Root directory of ECE server installation.
   rootDir: "/home/charging/opt/ECE/oceceserver"
   # Directory for ECE server logs.
   logsDir: "/home/charging/opt/ECE/oceceserver/logs"
# JMSConfiguration: Settings for Java Messaging Service, used for inter-service communication.
JMSConfiguration:
   NotificationQueue:
      # Identifier for the BRM (Billing and Revenue Management) cluster
      - Cluster: "BRM"
        # Hostname of the JMS server.
        HostName:
        # Port on which JMS server is listening.
        Port:
        # Username for authentication.
        UserName: weblogic
        # Communication protocol used.
        Protocol: t3://
        # Full URL for connection.
        ConnectionURL:
        # Number of times to retry connection on failure.
        ConnectionRetryCount: 10
        # Location of the SSL keystore for secure connections
        KeyStoreLocation: client.jks
        # Name of the external secret containing server SSL Key store, if present
        extJMSKeyStoreSecret:
        # Location of the ECE wallet for secure transactions.
        EceWalletLocation: /home/charging/wallet/ecewallet/
   # Similar configurations for other queues, indicating the system's modular approach to handling different types of notifications.
   BRMGatewayNotificationQueue:
      - Cluster: "BRM"
        HostName:
        Port:
        UserName: weblogic
        Protocol: t3://
        ConnectionURL:
        KeyStoreLocation: client.jks
        extJMSKeyStoreSecret:
        EceWalletLocation: /home/charging/wallet/ecewallet/
   # Similar configurations for other queues, indicating the system's modular approach to handling different types of notifications.
   DiameterGatewayNotificationQueue:
      - Cluster: "BRM"
        HostName:
        Port:
        UserName: weblogic
        Protocol: t3://
        ConnectionURL:
        KeyStoreLocation: client.jks
        extJMSKeyStoreSecret:
        EceWalletLocation: /home/charging/wallet/ecewallet/

# REFPluginConfiguration: Database connection settings for the Rating and billing Engine (REF).
REFPluginConfiguration:
   # Primary database connection URL.
   connectionURL1:
   connectionURL2:
   connectionURL3:
   # Primary Database user.
   user1: "pin"
   user2:
   user3:
   # Location of the database wallet for secure connections.
   wallet_location:
   wallet_entry_name1: "brm.db.pwd"
   wallet_entry_name2:
   wallet_entry_name3:
   # Whether to validate database schema on connection.
   validateSchema: "true"
   # Initial size of the database connection pool.
   initialPoolSize: 1
   # Minimum number of connections in the pool.
   minPoolSize: 1
   # Maximum number of connections in the pool.
   maxPoolSize: 50
   # Time in seconds to wait for a connection from the pool
   connectionWaitTimeout: 5
   # Whether to validate connections on borrow
   validateConnectionOnBorrow: "false"
   # SQL query used to validate a connection
   sqlForValidateConnection: "SELECT SYSDATE FROM DUAL"
   # Whether fast connection failover is enabled
   fastConnectionFailoverEnabled: "false"
   onsConfiguration:
   # Maximum number of statements allowed in the pool
   maxStatements: 50
   # Whether JMX monitoring is enabled
   jmxEnabled: "true"
   # Interval in seconds for updating metrics
   metricUpdateInterval: 10
   # Log level for connection pool messages
   poolLogLevel: "INFO"
   # Directory for control files
   control_file_dir:
   # Number of threads for loading operations
   load_thread_capacity: 30
   # Number of threads for update operations
   update_thread_capacity: 20
   # Number of concurrent updaters
   concurrent_updaters: 4
   # Backlog limit for updaters
   updater_backlog_limit: 50
   # Reference mode
   refmode: "DIRECT"
   # Process used for creation
   creation_process: "RATING_PIPELINE"
   # Success mode for operations
   successmode: "delete"
   # Indicates whether SSL for database connection is enabled (set to "true" to enable)
   dbSSLEnabled: "false"
   # Indicates whether client authentication is required for SSL/TLS connection
   dbSSLClientAuth: "false"
   # File path to the SSL/TLS truststore location for database connection
   sslTrustStoreLocation: "/scratch/db_wallet/cwallet.sso"
   # File path to the SSL/TLS keystore location for database connection
   sslKeyStoreLocation: "/scratch/db_wallet/cwallet.sso"
   # Password for accessing the SSL/TLS truststore
   sslTrustStorePwd: "infranet.rel.db.ssl.truststore.password"
   # Password for accessing the SSL/TLS keystore
   sslKeyStorePwd: "infranet.rel.db.ssl.keystore.password"

cmService:
    # IP address for the CM service.
    ipaddress:
    # Port for CM service communication.
    port: 11960
    # Target port for routing traffic.
    targetPort: 27015
brmgatewayService:
    port: 15502
cdrgatewayService:
    port: 8084
diametergatewayService:
    port: 3868
    type: NodePort
radiusgatewayService:
    port: 1812
    type: NodePort
httpgatewayService:
    port: 8080
    type: NodePort
jmxservice:
    port: ""
    # Type of the service
    # NodePort allows access to application from outside
    type: NodePort
monitoringagent:
    # NodePort allows access to application from outside
    type: NodePort

# pv and pvc: Definitions for persistent volumes and claims, providing storage resources in a Kubernetes environment.
pv:
   external:
       # Name of the external persistent volume.
       name: external-pv
       createOption: {}
       # Access mode, allowing multiple nodes to read/write.
       accessModes: ReadWriteMany
       # Capacity of the volume.
       capacity: 500Mi
# Definitions for other persistent volumes and volume claims, catering to different components like logs, BRM configuration, SDKs, cdrformatter, wallet and external.
pvc:
   logs:
       name: logs-pvc
       accessModes: ReadWriteMany
       storage: 500Mi
       createOption: {}
   brmconfig:
       name: brmconfig-pvc
       accessModes: ReadWriteMany
       storage: 500Mi
       createOption: {}
   sdk:
       name: sdk-pvc
       accessModes: ReadWriteMany
       storage: 500Mi
       createOption: {}
   cdrformatter:
     name: cdrformatter-pvc
     accessModes: ReadWriteMany
     storage: 500Mi
     createOption: {}
   wallet:
       name: ece-wallet-pvc
       accessModes: ReadWriteMany
       storage: 500Mi
       createOption: {}
   external:
       name: external-pvc
       accessModes: ReadWriteMany
       storage: 500Mi

# storageClass: Specifies the StorageClass for dynamic volume provisioning, if needed.
storageClass:
   # Name of the StorageClass to use.
   name: brm-shared-vol-dev4