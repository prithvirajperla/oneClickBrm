# Copyright (c) 2025 Oracle and/or its affiliates.

# Default values for mychart.
# This is a YAML-formatted file.
# Declare variables to be passed into your templates.

# For non-empty repository, "/" MUST be appended
imageRepository: "fra.ocir.io/fry4fxlvxkjt/communications_monetization/"
imagePullSecrets:
    # For multiple pull secrets add the name: "secret" below again
    - name: "brm-registry"
uniPass: "Q1RTdHJhaW5lcl8xMjMj"

db:
    # Shared Database Connection details
    # Specifies if DB is SSL enabled. Supported values are NO , ONE_WAY and TWO_WAY
    sslMode: "NO"
    extDBSSLWalletSecret: ""
    # Host name or IP Address of Database Server
    host:  ${DBHOST}
    # Port number of Database Server
    port: 1521
    # Name of the DB system administrator
    user: sys
    # Password of the DB system administrator
    password: "${DBPASS}"
    # Service Name which identifies DB
    serviceName:  ${DBSERVICE}
    # Role assigned to this DBA user
    role: sysdba
    # Password of the DB SSL wallet. Required if isslMode is ONE_WAY
    walletPassword:
    walletType: sso

ocbrm:
    brm_root_pass: "Q1RTdHJhaW5lcl8xMjMj"
    wallet:
        client: "Q1RTdHJhaW5lcl8xMjMj"
        server: "Q1RTdHJhaW5lcl8xMjMj"
        root: "Q1RTdHJhaW5lcl8xMjMj"


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
        # Specifies if DB is SSL enabled. Supported values are NO , ONE_WAY and TWO_WAY
        sslMode: NO
        # Password of the DB SSL wallet. Required if sslMode is set to "ONE_WAY"
        walletPassword:
        # Specify the DB SSL wallet type: pkcs12 or sso
        walletType: sso
        # Set enable_partition: No , if partitioning is disabled at database level or want to skip partitioning
        enable_partition: 'Yes'
        # Set storage_model to determine size of BRM database tablespaces
        storage_model: 'Large'
        schemauser: pin
        schemapass: "${PINPASS}"
        schematablespace: pin00
        indextablespace: pinx00
        nls_lang: AMERICAN_AMERICA.AL32UTF8
        pipelineschemauser: pin
        pipelineschemapass: "${PINPASS}"
        pipelineschematablespace: pin00
        pipelineindextablespace: pinx00


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
                adminServerNodePort: 30408
                log_enabled: false
                minPoolSize: 1
                maxPoolSize: 8
                poolTimeout: 30000
                jvmOpts: "-Dweblogic.StdoutDebugEnabled=false -Dweblogic.security.remoteAnonymousRMIT3Enabled=false -Dweblogic.security.remoteAnonymousRMIIIOPEnabled=false"
                userMemArgs: "-Xms768m -Xmx2048m -XX:+UseContainerSupport -Djava.security.egd=file:/dev/./urandom"
                serverStartPolicy: IF_NEEDED


ocpdc:

     # Setting true to will deploy PDC, setting false will undeploy/do not deploy PDC
     isEnabled: true
     configEnv:
        t3ChannelPort: 30401
        t3sChannelPort: 30333
        # Mandatory -RCU Connection String, Format: DBHostName:DBPort/DBService
        rcuJdbcURL:  ${DBHOST}:1521/${DBSERVICE}
        # PDC Domain RCU Schema prefix, If prefix is XYZ then XYZ_STB will be created.
        rcuPrefix: rcupdcdev3
        # Mandatory: PDC Domain RCU drop and reccreate if already present
        rcuRecreate: true
        # PDC and Cross Reference DB Host-name.
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
        dbWalletType: "sso"
        # Name of the custom SSL secret for PDC DB
        extPDCDBSSLWalletSecret: ""
        # Mandatory: Cross Reference DB Schema PDC Table Space.
        crossRefSchemaPDCTableSpace: "PDC_DATA"
        # Mandatory: Cross Reference DB Schema PDC TEMP Table Space.
        crossRefSchemaTempTableSpace: "PDC_TEMP"
        # Mandatory: Cross Reference DB Schema User-name.
        crossRefSchemaUserName: "PDCXREF"
        # Mandatory: DC Application Schema PDC Table Space.
        pdcSchemaPDCTableSpace: "PDC_DATA"
        # Mandatory: PDC Application Schema TEMP Table.
        pdcSchemaTempTableSpace: "PDC_TEMP"
        # Mandatory: PDC Application Schema User-name.
        pdcSchemaUserName: "PDC"
        # Optional: RCU Wallet Schema User-name.
        rcuWalletSchemaUserName: "PDCRCUWALLET"
        # Mandatory: PDC Application Admin User-name, it is not recommended to use weblogic.
        pdcAdminUser: "cnepdcadminuser"


     # PDC Secret Password keys of PDC
     secretValue:
        # Domain adminUser password
        adminPassword: "Q1RTdHJhaW5lcl8xMjMj"
        # PDC Domain RCU Schema Password
        rcuSchemaPassword: "Q1RTdHJhaW5lcl8xMjMj"
        # Mandatory: PDC Domain SSL Identity Key Password
        # Default password 'UERDU1NMUGFzczEyMyM=' which is 'PDCSSLPass123#'
        keyStoreIdentityKeyPass: "UERDU1NMUGFzczEyMyM="
        # Mandatory: PDC Domain SSL Identity Key Store Password
        # Default password 'UERDU1NMUGFzczEyMyM=' which is 'PDCSSLPass123#'
        keyStoreIdentityStorePass: "UERDU1NMUGFzczEyMyM="
        # Mandatory: PDC Domain SSL Custom Trust Store Password
        # Default password 'UERDU1NMUGFzczEyMyM=' which is 'PDCSSLPass123#'
        keyStoreTrustStorePass: "UERDU1NMUGFzczEyMyM="
        # PDC and Cross Reference Schema SYS/System User Password
        dbPassword: "${DBPASS}"
        # PDC Application DB Schema Password
        pdcSchemaPassword: "${PINPASS}"
        # PDC Cross Reference Schema Password
        crossRefSchemaPassword: "${PINPASS}"
        # Mandatory: PDC RCU OPSS Wallet Schema Password
        # Default password 'UERDI1JDVVdhbGxldDEyMyM=' which is 'PDC#RCUWallet123#'
        rcuWalletSchemaPassword: "Q1RTdHJhaW5lcl8xMjMj"
        # Password of the DB SSL wallet. Required if walletType = pkcs12 Y2didTEyMzQ=
        dbWalletPassword: "Q1RTdHJhaW5lcl8xMjMj"
        # PDC Application Wallet and PDC BRM Integration Wallet password
        walletPassword: "Q1RTdHJhaW5lcl8xMjMj"
        # PDC Application AdminUser Password
        pdcAdminUserPassword: "Q1RTdHJhaW5lcl8xMjMj"

     service:
        name: "pdc-service"
        type: "NodePort"
        nodePort: 30400

ocboc:

    # Values used for Business Opearations Center application and its domain
    boc:
        # A boolean value to add (true) or remove (false) Billing Care and
        isEnabled: true
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
            dbHost: "${DBHOST}"
            # Port number of Database Server
            dbPort: 1521
            # Service Name which identifies DB
            dbServiceName: "${DBSERVICE}"
            rcuSysDBAUser: SYS
            # Role of database administrator user
            rcuDBARole: SYSDBA
            # Prefix for schemas of OPSS
            rcuPrefix: BOC11
            rcuRecreate: true
            rcuTablespace: "PIN_DATA"
            rcuTempTablespace: "PIN_TEMP"
            # Production setup must use OPSS (true) only
            isOPSS: false
            ldapPort: 389
            bocSchemaUserName: bocdb
            bocSchemaBocTablespace: boc_default_tbls
            bocSchemaTempTablespace: boc_temp_tbls
            dbURL: "${DBHOST}:1521/${DBSERVICE}"
        secretVal:
            # Password of the WebLogic Domain's administrative user (configEnv.adminUser)
            adminPassword: "Q1RTdHJhaW5lcl8xMjMj"
            # Password of the Ldap Server Admin User (configEnv.ldapAdmin)
            ldapPassword: "Q1RTdHJhaW5lcl8xMjMj"
            # Password of the Database Administrator (configEnv.rcuSysDBAUser)
            rcuSysDBAPassword: "REJhZG1pbl8xMjMj"
            # Password of the OPSS schema (configEnv.rcuPrefix)
            rcuSchemaPassword: "Q1RTdHJhaW5lcl8xMjMj"
            #The Business Operations Center database administrator password.
            bocSchemaPassword: "Q1RTdHJhaW5lcl8xMjMj"
            # Password for truststore
            dbWalletPassword: "Q1RTdHJhaW5lcl8xMjMj"
            # StorePass of Identity Keystore
            keystoreIdentityPassword: "Q1RTdHJhaW5lcl8xMjMj"
            # KeyPass of Identity Keystore
            keystoreKeyPassword: "Q1RTdHJhaW5lcl8xMjMj"
            # StorePass of Trust Keystore
            keystoreTrustPassword: "Q1RTdHJhaW5lcl8xMjMj"
        wop:
            # Name of the domain
            # Used as prefix to tag related objects
            domainUID: boc-domain
            # Location within container where domain is created
            domainRootDir: /shared
            # Total number of managed servers forming the cluster
            totalManagedServers: 5
            # Number of managed servers to initially start for the domain
            initialServerCount: 1
            # NodePort where admin-server's http service will be accessible
            adminChannelPort: 30404

        # Add users and groups to domain's DefaultAuthenticator (local)
        wlsUserGroups:
            # New groups to be added locally to this domain
            # Each element for this takes "name" and "description", like:
            # -   name:
            #     description:
            groups:
            - name: "BOC_ADMIN"
              description: "BOC Admin Group"
            - name: "BOC_FINANCE"
              description: "BOC Finance Group"
            # New users to be added locally to this domain
            # Each element for this takes "name", "description", "password" (base64 encoded) and list of "groups" that he is part of, like:
            # -   name:
            #     description:
            #     password:
            #     groups:
            #     - "Regular CSR"
            users:
            - name: "bocuser"
              description: "BOC User"
              password: "Q1RTdHJhaW5lcl8xMjMj"
              groups:
              - "BOC_ADMIN"
              - "BOC_FINANCE"
        extensions:
            # Name of configmap containing scripts to execute additional steps to configure domain and/or application
            scriptsConfigName: ""
        # Define rules for scheduling WebLogic Server pods on particular nodes
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
            dbSSLMode: NO
            # Specify the DB SSL wallet type: SSO
            rcuJdbcURL:  ${DBHOST}:1521/${DBSERVICE}
            # Database administrator user name
            rcuSysDBAUser: SYS
            # Role of database administrator user
            rcuDBARole: SYSDBA
            # Prefix for schemas of OPSS
            rcuPrefix: BC01
            # Drops existing OPSS schema already exists if true. One of true, false
            rcuRecreate: true
            # Additional arguments to create rcu
            rcuArgs: " "
            rcuTablespace: "PIN_DATA "
            rcuTempTablespace: "PIN_TEMP "
            # Create an OPSS or non-OPSS domain. One of true, false
            # Production setup must use OPSS (true) only
            isOPSS: false
            isLDAPEnabled: false
        secretVal:
            # Password of the WebLogic Domain's administrative user (configEnv.adminUser)
            adminPassword: "Q1RTdHJhaW5lcl8xMjMj"
            # Password of the Ldap Server Admin User (configEnv.ldapAdmin)
            ldapPassword: "Q1RTdHJhaW5lcl8xMjMj"
            # Password of the Database Administrator (configEnv.rcuSysDBAUser)
            rcuSysDBAPassword: "REJhZG1pbl8xMjMj"
            # Password of the OPSS schema (configEnv.rcuPrefix)
            rcuSchemaPassword: "Q1RTdHJhaW5lcl8xMjMj"
            # Password for truststore
            dbWalletPassword: "Q1RTdHJhaW5lcl8xMjMj"
            # StorePass of Identity Keystore
            keystoreIdentityPassword: "Q1RTdHJhaW5lcl8xMjMj"
            # KeyPass of Identity Keystore
            keystoreKeyPassword: "Q1RTdHJhaW5lcl8xMjMj"
            # StorePass of Trust Keystore
            keystoreTrustPassword: "Q1RTdHJhaW5lcl8xMjMj"
        wop:
            # Number of managed servers to initially start for the domain
            initialServerCount: 1
            # NodePort where admin-server's http service will be accessible
            adminChannelPort: 30405
            # serverStartPolicy legal values are "NEVER", "IF_NEEDED", or "ADMIN_ONLY"
            # This determines which WebLogic Servers the Operator will start up when it discovers this Domain
            # - "NEVER" will not start any server in the domain
            # - "ADMIN_ONLY" will start up only the administration server (no managed servers will be started)
            # - "IF_NEEDED" will start all non-clustered servers, including the administration server and clustered servers up to the replica count
            serverStartPolicy: "IF_NEEDED"
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
              password: "Q1RTdHJhaW5lcl8xMjMj"
              groups:
              - "POC"

    bcws:
        # A boolean value to add (true) or remove (false) Billing Care REST API
        # and all its associated resources
        isEnabled: true
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
            dbSSLMode: NO
            # Specify the DB SSL wallet type: SSO
            dbWalletType: SSO
            # Name of the secret containing SSL DB wallet
            extDBSSLWalletSecret: ""
            # Database connection details where OPSS schema will be created
            # DB Connection URL, valid formats:
            # SSL enabled DB: (DESCRIPTION=(ADDRESS=(PROTOCOL=tcps)(HOST=__DB_HOST__)(PORT=__DB_SSL_PORT__))(CONNECT_DATA=(SERVICE_NAME=__DB_SERVICE_NAME__)))
            # SSL disabled DB: __DB_HOST__:__DB_PORT__/__DB_SERVICE_NAME__
            rcuJdbcURL:  ${DBHOST}:1521/${DBSERVICE}
            # Database administrator user name
            rcuSysDBAUser: SYS
            # Role of database administrator user
            rcuDBARole: SYSDBA
            # Prefix for schemas of OPSS
            rcuPrefix: BCWS01
            # Drops existing OPSS schema already exists if true. One of true, false
            rcuRecreate: true
            # Additional arguments to create rcu
            rcuArgs: " "
            rcuTablespace: "PIN_DATA "
            rcuTempTablespace: "PIN_TEMP"
            # Create an OPSS or non-OPSS domain. One of true, false
            # Production setup must use OPSS (true) only
            isOPSS: false
            isLDAPEnabled: false
        secretVal:
            # Password of the WebLogic Domain's administrative user (configEnv.adminUser)
            adminPassword: "Q1RTdHJhaW5lcl8xMjMj"
            # Password of the Ldap Server Admin User (configEnv.ldapAdmin)
            ldapPassword: "Q1RTdHJhaW5lcl8xMjMj"
            # Password of the Database Administrator (configEnv.rcuSysDBAUser)
            rcuSysDBAPassword: "REJhZG1pbl8xMjMj"
            # Password of the OPSS schema (configEnv.rcuPrefix)
            rcuSchemaPassword: "Q1RTdHJhaW5lcl8xMjMj"
            # Password for truststore
            dbWalletPassword: "Q1RTdHJhaW5lcl8xMjMj"
            # StorePass of Identity Keystore
            keystoreIdentityPassword: "Q1RTdHJhaW5lcl8xMjMj"
            # KeyPass of Identity Keystore
            keystoreKeyPassword: "Q1RTdHJhaW5lcl8xMjMj"
            # StorePass of Trust Keystore
            keystoreTrustPassword: "Q1RTdHJhaW5lcl8xMjMj"
        wop:
            initialServerCount: 1
            # NodePort where admin-server's http service will be accessible
            adminChannelPort: 30406
            # serverStartPolicy legal values are "NEVER", "IF_NEEDED", or "ADMIN_ONLY"
            # This determines which WebLogic Servers the Operator will start up when it discovers this Domain
            # - "NEVER" will not start any server in the domain
            # - "ADMIN_ONLY" will start up only the administration server (no managed servers will be started)
            # - "IF_NEEDED" will start all non-clustered servers, including the administration server and clustered servers up to the replica count
            serverStartPolicy: "IF_NEEDED"
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
              password: "Q1RTdHJhaW5lcl8xMjMj"
              groups:
              - "POC"
        extensions:
            # Name of configmap containing scripts to execute additional steps to configure domain and/or application
            scriptsConfigName: ""
        # Define rules for scheduling WebLogic Server pods on particular nodes
        pod:
         #addOnPodSpec: {}
         #Add details which will be injected to pod spec
         addOnPodSpec:
             securityContext:
                runAsUser: 1000
                runAsGroup: 3000
                fsGroup: 2000
                fsGroupChangePolicy: "OnRootMismatch"
