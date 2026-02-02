# Copyright (c) 2023, 2025, Oracle and/or its affiliates
# t

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
    host: ${DBIP}
    # Port number of Database Server
    port: 1521
    # Name of the DB system administrator
    user: sys as sysdba
    # Password of the DB system administrator
    password: "${DBPASS}"

ocbrm:
    imagePullPolicy: IfNotPresent
    # Set isAmt: true , if AMT is going to be used
    isAmt: false
    # Set isIPV6Enabled: true if the IPV6 is enabled in the Kubernetes environment
    isIPV6Enabled: false
    # Set ece_deployed: false , if ECE is not going to be deployed
    ece_deployed: true
    # Set pdc_deployed: true , if PDC is going to be deployed
    pdc_deployed: true
    # Set existing_rootkey_wallet: true , if existing database is used (non init-db ) or if exisiting root-key wallet is used.
    existing_rootkey_wallet: false
    extExistingRootKeyWalletSecret:
    # Set is_upgrade flag to true for DB upgrade from PS3 to PS4, else set to false for fresh db initialization.
    is_upgrade: false
    TZ: UTC
    LOG_LEVEL: 3
    isSSLEnabled: true
    # SSL is enabled when set to true and disabled when set to false
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
    brm_root_pass: ""
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
        client: "Q1RTdHJhaW5lcl8xMjMj"
        server: "Q1RTdHJhaW5lcl8xMjMj"
        root: "Q1RTdHJhaW5lcl8xMjMj"

    db:
        deployment:
            imageName: init_db
            imageTag: 15.1.0.0.0
        host: "${DBHOST}"
        port: 1521
        service: "${DBSERVICE}"
        # Specifies if DB is SSL enabled. Supported values are NO , ONE_WAY and TWO_WAY
        sslMode: NO
        # Password of the DB SSL wallet. Required if sslMode is set to "ONE_WAY"
        walletPassword: "Q1RTdHJhaW5lcl8xMjMj"
        # Specify the DB SSL wallet type: pkcs12 or sso
        walletType: sso
        # Set enable_partition: No , if partitioning is disabled at database level or want to skip partitioning
        enable_partition: 'Yes'
        # Set storage_model to determine size of BRM database tablespaces
        storage_model: 'Large'
        schemauser: pin
        schemapass: "${PINPASS}"
        schematablespace: PIN00
        indextablespace: PINX00
        nls_lang: AMERICAN_AMERICA.AL32UTF8
        pipelineschemauser: pin
        pipelineschemapass: "${PINPASS}"
        pipelineschematablespace: PIN00
        pipelineindextablespace: PINX00
        # Set skipPrimary: true , if new schema needs to be initilized in a multi-schema setup
        skipPrimary: false
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

    upgrade:
        deployment:
            imageName: upgrade
            imageTag: 15.1.0.0.0
