# Copyright  The cert-manager Authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
---
apiVersion: apiextensions.k8s.io/v1
kind: CustomResourceDefinition
metadata:
    annotations:
        cert-manager.io/inject-ca-from-secret: cert-manager/cert-manager-webhook-ca
    labels:
        app: cert-manager
        app.kubernetes.io/instance: cert-manager
        app.kubernetes.io/managed-by: Helm
        app.kubernetes.io/name: cert-manager
        helm.sh/chart: cert-manager-v1.4.0
    name: certificaterequests.cert-manager.io
spec:
    conversion:
        strategy: Webhook
        webhook:
            clientConfig:
                service:
                    name: cert-manager-webhook
                    namespace: ${namespace}
                    path: /convert
            conversionReviewVersions:
                - v1
                - v1beta1
    group: cert-manager.io
    names:
        categories:
            - cert-manager
        kind: CertificateRequest
        listKind: CertificateRequestList
        plural: certificaterequests
        shortNames:
            - cr
            - crs
        singular: certificaterequest
    scope: Namespaced
    versions:
        - additionalPrinterColumns:
            - jsonPath: .status.conditions[?(@.type=="Approved")].status
              name: Approved
              type: string
            - jsonPath: .status.conditions[?(@.type=="Denied")].status
              name: Denied
              type: string
            - jsonPath: .status.conditions[?(@.type=="Ready")].status
              name: Ready
              type: string
            - jsonPath: .spec.issuerRef.name
              name: Issuer
              type: string
            - jsonPath: .spec.username
              name: Requestor
              type: string
            - jsonPath: .status.conditions[?(@.type=="Ready")].message
              name: Status
              priority: 1
              type: string
            - description: CreationTimestamp is a timestamp representing the server time when this object was created. It is not guaranteed to be set in happens-before order across separate operations. Clients may not set this value. It is represented in RFC3339 form and is in UTC.
              jsonPath: .metadata.creationTimestamp
              name: Age
              type: date
          name: v1alpha2
          schema:
            openAPIV3Schema:
                description: "A CertificateRequest is used to request a signed certificate from one of the configured issuers. \n All fields within the CertificateRequest's `spec` are immutable after creation. A CertificateRequest will either succeed or fail, as denoted by its `status.state` field. \n A CertificateRequest is a one-shot resource, meaning it represents a single point in time request for a certificate and cannot be re-used."
                properties:
                    apiVersion:
                        description: 'APIVersion defines the versioned schema of this representation of an object. Servers should convert recognized schemas to the latest internal value, and may reject unrecognized values. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources'
                        type: string
                    kind:
                        description: 'Kind is a string value representing the REST resource this object represents. Servers may infer this from the endpoint the client submits requests to. Cannot be updated. In CamelCase. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds'
                        type: string
                    metadata:
                        type: object
                    spec:
                        description: Desired state of the CertificateRequest resource.
                        properties:
                            csr:
                                description: The PEM-encoded x509 certificate signing request to be submitted to the CA for signing.
                                format: byte
                                type: string
                            duration:
                                description: The requested 'duration' (i.e. lifetime) of the Certificate. This option may be ignored/overridden by some issuer types.
                                type: string
                            extra:
                                additionalProperties:
                                    items:
                                        type: string
                                    type: array
                                description: Extra contains extra attributes of the user that created the CertificateRequest. Populated by the cert-manager webhook on creation and immutable.
                                type: object
                            groups:
                                description: Groups contains group membership of the user that created the CertificateRequest. Populated by the cert-manager webhook on creation and immutable.
                                items:
                                    type: string
                                type: array
                                x-kubernetes-list-type: atomic
                            isCA:
                                description: IsCA will request to mark the certificate as valid for certificate signing when submitting to the issuer. This will automatically add the `cert sign` usage to the list of `usages`.
                                type: boolean
                            issuerRef:
                                description: IssuerRef is a reference to the issuer for this CertificateRequest.  If the `kind` field is not set, or set to `Issuer`, an Issuer resource with the given name in the same namespace as the CertificateRequest will be used.  If the `kind` field is set to `ClusterIssuer`, a ClusterIssuer with the provided name will be used. The `name` field in this stanza is required at all times. The group field refers to the API group of the issuer which defaults to `cert-manager.io` if empty.
                                properties:
                                    group:
                                        description: Group of the resource being referred to.
                                        type: string
                                    kind:
                                        description: Kind of the resource being referred to.
                                        type: string
                                    name:
                                        description: Name of the resource being referred to.
                                        type: string
                                required:
                                    - name
                                type: object
                            uid:
                                description: UID contains the uid of the user that created the CertificateRequest. Populated by the cert-manager webhook on creation and immutable.
                                type: string
                            usages:
                                description: Usages is the set of x509 usages that are requested for the certificate. Defaults to `digital signature` and `key encipherment` if not specified.
                                items:
                                    description: 'KeyUsage specifies valid usage contexts for keys. See: https://tools.ietf.org/html/rfc5280#section-4.2.1.3      https://tools.ietf.org/html/rfc5280#section-4.2.1.12 Valid KeyUsage values are as follows: "signing", "digital signature", "content commitment", "key encipherment", "key agreement", "data encipherment", "cert sign", "crl sign", "encipher only", "decipher only", "any", "server auth", "client auth", "code signing", "email protection", "s/mime", "ipsec end system", "ipsec tunnel", "ipsec user", "timestamping", "ocsp signing", "microsoft sgc", "netscape sgc"'
                                    enum:
                                        - signing
                                        - digital signature
                                        - content commitment
                                        - key encipherment
                                        - key agreement
                                        - data encipherment
                                        - cert sign
                                        - crl sign
                                        - encipher only
                                        - decipher only
                                        - any
                                        - server auth
                                        - client auth
                                        - code signing
                                        - email protection
                                        - s/mime
                                        - ipsec end system
                                        - ipsec tunnel
                                        - ipsec user
                                        - timestamping
                                        - ocsp signing
                                        - microsoft sgc
                                        - netscape sgc
                                    type: string
                                type: array
                            username:
                                description: Username contains the name of the user that created the CertificateRequest. Populated by the cert-manager webhook on creation and immutable.
                                type: string
                        required:
                            - csr
                            - issuerRef
                        type: object
                    status:
                        description: Status of the CertificateRequest. This is set and managed automatically.
                        properties:
                            ca:
                                description: The PEM encoded x509 certificate of the signer, also known as the CA (Certificate Authority). This is set on a best-effort basis by different issuers. If not set, the CA is assumed to be unknown/not available.
                                format: byte
                                type: string
                            certificate:
                                description: The PEM encoded x509 certificate resulting from the certificate signing request. If not set, the CertificateRequest has either not been completed or has failed. More information on failure can be found by checking the `conditions` field.
                                format: byte
                                type: string
                            conditions:
                                description: List of status conditions to indicate the status of a CertificateRequest. Known condition types are `Ready` and `InvalidRequest`.
                                items:
                                    description: CertificateRequestCondition contains condition information for a CertificateRequest.
                                    properties:
                                        lastTransitionTime:
                                            description: LastTransitionTime is the timestamp corresponding to the last status change of this condition.
                                            format: date-time
                                            type: string
                                        message:
                                            description: Message is a human readable description of the details of the last transition, complementing reason.
                                            type: string
                                        reason:
                                            description: Reason is a brief machine readable explanation for the condition's last transition.
                                            type: string
                                        status:
                                            description: Status of the condition, one of (`True`, `False`, `Unknown`).
                                            enum:
                                                - "True"
                                                - "False"
                                                - Unknown
                                            type: string
                                        type:
                                            description: Type of the condition, known values are (`Ready`, `InvalidRequest`, `Approved`, `Denied`).
                                            type: string
                                    required:
                                        - status
                                        - type
                                    type: object
                                type: array
                            failureTime:
                                description: FailureTime stores the time that this CertificateRequest failed. This is used to influence garbage collection and back-off.
                                format: date-time
                                type: string
                        type: object
                type: object
          served: true
          storage: false
          subresources:
            status: {}
        - additionalPrinterColumns:
            - jsonPath: .status.conditions[?(@.type=="Approved")].status
              name: Approved
              type: string
            - jsonPath: .status.conditions[?(@.type=="Denied")].status
              name: Denied
              type: string
            - jsonPath: .status.conditions[?(@.type=="Ready")].status
              name: Ready
              type: string
            - jsonPath: .spec.issuerRef.name
              name: Issuer
              type: string
            - jsonPath: .spec.username
              name: Requestor
              type: string
            - jsonPath: .status.conditions[?(@.type=="Ready")].message
              name: Status
              priority: 1
              type: string
            - description: CreationTimestamp is a timestamp representing the server time when this object was created. It is not guaranteed to be set in happens-before order across separate operations. Clients may not set this value. It is represented in RFC3339 form and is in UTC.
              jsonPath: .metadata.creationTimestamp
              name: Age
              type: date
          name: v1alpha3
          schema:
            openAPIV3Schema:
                description: "A CertificateRequest is used to request a signed certificate from one of the configured issuers. \n All fields within the CertificateRequest's `spec` are immutable after creation. A CertificateRequest will either succeed or fail, as denoted by its `status.state` field. \n A CertificateRequest is a one-shot resource, meaning it represents a single point in time request for a certificate and cannot be re-used."
                properties:
                    apiVersion:
                        description: 'APIVersion defines the versioned schema of this representation of an object. Servers should convert recognized schemas to the latest internal value, and may reject unrecognized values. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources'
                        type: string
                    kind:
                        description: 'Kind is a string value representing the REST resource this object represents. Servers may infer this from the endpoint the client submits requests to. Cannot be updated. In CamelCase. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds'
                        type: string
                    metadata:
                        type: object
                    spec:
                        description: Desired state of the CertificateRequest resource.
                        properties:
                            csr:
                                description: The PEM-encoded x509 certificate signing request to be submitted to the CA for signing.
                                format: byte
                                type: string
                            duration:
                                description: The requested 'duration' (i.e. lifetime) of the Certificate. This option may be ignored/overridden by some issuer types.
                                type: string
                            extra:
                                additionalProperties:
                                    items:
                                        type: string
                                    type: array
                                description: Extra contains extra attributes of the user that created the CertificateRequest. Populated by the cert-manager webhook on creation and immutable.
                                type: object
                            groups:
                                description: Groups contains group membership of the user that created the CertificateRequest. Populated by the cert-manager webhook on creation and immutable.
                                items:
                                    type: string
                                type: array
                                x-kubernetes-list-type: atomic
                            isCA:
                                description: IsCA will request to mark the certificate as valid for certificate signing when submitting to the issuer. This will automatically add the `cert sign` usage to the list of `usages`.
                                type: boolean
                            issuerRef:
                                description: IssuerRef is a reference to the issuer for this CertificateRequest.  If the `kind` field is not set, or set to `Issuer`, an Issuer resource with the given name in the same namespace as the CertificateRequest will be used.  If the `kind` field is set to `ClusterIssuer`, a ClusterIssuer with the provided name will be used. The `name` field in this stanza is required at all times. The group field refers to the API group of the issuer which defaults to `cert-manager.io` if empty.
                                properties:
                                    group:
                                        description: Group of the resource being referred to.
                                        type: string
                                    kind:
                                        description: Kind of the resource being referred to.
                                        type: string
                                    name:
                                        description: Name of the resource being referred to.
                                        type: string
                                required:
                                    - name
                                type: object
                            uid:
                                description: UID contains the uid of the user that created the CertificateRequest. Populated by the cert-manager webhook on creation and immutable.
                                type: string
                            usages:
                                description: Usages is the set of x509 usages that are requested for the certificate. Defaults to `digital signature` and `key encipherment` if not specified.
                                items:
                                    description: 'KeyUsage specifies valid usage contexts for keys. See: https://tools.ietf.org/html/rfc5280#section-4.2.1.3      https://tools.ietf.org/html/rfc5280#section-4.2.1.12 Valid KeyUsage values are as follows: "signing", "digital signature", "content commitment", "key encipherment", "key agreement", "data encipherment", "cert sign", "crl sign", "encipher only", "decipher only", "any", "server auth", "client auth", "code signing", "email protection", "s/mime", "ipsec end system", "ipsec tunnel", "ipsec user", "timestamping", "ocsp signing", "microsoft sgc", "netscape sgc"'
                                    enum:
                                        - signing
                                        - digital signature
                                        - content commitment
                                        - key encipherment
                                        - key agreement
                                        - data encipherment
                                        - cert sign
                                        - crl sign
                                        - encipher only
                                        - decipher only
                                        - any
                                        - server auth
                                        - client auth
                                        - code signing
                                        - email protection
                                        - s/mime
                                        - ipsec end system
                                        - ipsec tunnel
                                        - ipsec user
                                        - timestamping
                                        - ocsp signing
                                        - microsoft sgc
                                        - netscape sgc
                                    type: string
                                type: array
                            username:
                                description: Username contains the name of the user that created the CertificateRequest. Populated by the cert-manager webhook on creation and immutable.
                                type: string
                        required:
                            - csr
                            - issuerRef
                        type: object
                    status:
                        description: Status of the CertificateRequest. This is set and managed automatically.
                        properties:
                            ca:
                                description: The PEM encoded x509 certificate of the signer, also known as the CA (Certificate Authority). This is set on a best-effort basis by different issuers. If not set, the CA is assumed to be unknown/not available.
                                format: byte
                                type: string
                            certificate:
                                description: The PEM encoded x509 certificate resulting from the certificate signing request. If not set, the CertificateRequest has either not been completed or has failed. More information on failure can be found by checking the `conditions` field.
                                format: byte
                                type: string
                            conditions:
                                description: List of status conditions to indicate the status of a CertificateRequest. Known condition types are `Ready` and `InvalidRequest`.
                                items:
                                    description: CertificateRequestCondition contains condition information for a CertificateRequest.
                                    properties:
                                        lastTransitionTime:
                                            description: LastTransitionTime is the timestamp corresponding to the last status change of this condition.
                                            format: date-time
                                            type: string
                                        message:
                                            description: Message is a human readable description of the details of the last transition, complementing reason.
                                            type: string
                                        reason:
                                            description: Reason is a brief machine readable explanation for the condition's last transition.
                                            type: string
                                        status:
                                            description: Status of the condition, one of (`True`, `False`, `Unknown`).
                                            enum:
                                                - "True"
                                                - "False"
                                                - Unknown
                                            type: string
                                        type:
                                            description: Type of the condition, known values are (`Ready`, `InvalidRequest`, `Approved`, `Denied`).
                                            type: string
                                    required:
                                        - status
                                        - type
                                    type: object
                                type: array
                            failureTime:
                                description: FailureTime stores the time that this CertificateRequest failed. This is used to influence garbage collection and back-off.
                                format: date-time
                                type: string
                        type: object
                type: object
          served: true
          storage: false
          subresources:
            status: {}
        - additionalPrinterColumns:
            - jsonPath: .status.conditions[?(@.type=="Approved")].status
              name: Approved
              type: string
            - jsonPath: .status.conditions[?(@.type=="Denied")].status
              name: Denied
              type: string
            - jsonPath: .status.conditions[?(@.type=="Ready")].status
              name: Ready
              type: string
            - jsonPath: .spec.issuerRef.name
              name: Issuer
              type: string
            - jsonPath: .spec.username
              name: Requestor
              type: string
            - jsonPath: .status.conditions[?(@.type=="Ready")].message
              name: Status
              priority: 1
              type: string
            - description: CreationTimestamp is a timestamp representing the server time when this object was created. It is not guaranteed to be set in happens-before order across separate operations. Clients may not set this value. It is represented in RFC3339 form and is in UTC.
              jsonPath: .metadata.creationTimestamp
              name: Age
              type: date
          name: v1beta1
          schema:
            openAPIV3Schema:
                description: "A CertificateRequest is used to request a signed certificate from one of the configured issuers. \n All fields within the CertificateRequest's `spec` are immutable after creation. A CertificateRequest will either succeed or fail, as denoted by its `status.state` field. \n A CertificateRequest is a one-shot resource, meaning it represents a single point in time request for a certificate and cannot be re-used."
                properties:
                    apiVersion:
                        description: 'APIVersion defines the versioned schema of this representation of an object. Servers should convert recognized schemas to the latest internal value, and may reject unrecognized values. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources'
                        type: string
                    kind:
                        description: 'Kind is a string value representing the REST resource this object represents. Servers may infer this from the endpoint the client submits requests to. Cannot be updated. In CamelCase. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds'
                        type: string
                    metadata:
                        type: object
                    spec:
                        description: Desired state of the CertificateRequest resource.
                        properties:
                            duration:
                                description: The requested 'duration' (i.e. lifetime) of the Certificate. This option may be ignored/overridden by some issuer types.
                                type: string
                            extra:
                                additionalProperties:
                                    items:
                                        type: string
                                    type: array
                                description: Extra contains extra attributes of the user that created the CertificateRequest. Populated by the cert-manager webhook on creation and immutable.
                                type: object
                            groups:
                                description: Groups contains group membership of the user that created the CertificateRequest. Populated by the cert-manager webhook on creation and immutable.
                                items:
                                    type: string
                                type: array
                                x-kubernetes-list-type: atomic
                            isCA:
                                description: IsCA will request to mark the certificate as valid for certificate signing when submitting to the issuer. This will automatically add the `cert sign` usage to the list of `usages`.
                                type: boolean
                            issuerRef:
                                description: IssuerRef is a reference to the issuer for this CertificateRequest.  If the `kind` field is not set, or set to `Issuer`, an Issuer resource with the given name in the same namespace as the CertificateRequest will be used.  If the `kind` field is set to `ClusterIssuer`, a ClusterIssuer with the provided name will be used. The `name` field in this stanza is required at all times. The group field refers to the API group of the issuer which defaults to `cert-manager.io` if empty.
                                properties:
                                    group:
                                        description: Group of the resource being referred to.
                                        type: string
                                    kind:
                                        description: Kind of the resource being referred to.
                                        type: string
                                    name:
                                        description: Name of the resource being referred to.
                                        type: string
                                required:
                                    - name
                                type: object
                            request:
                                description: The PEM-encoded x509 certificate signing request to be submitted to the CA for signing.
                                format: byte
                                type: string
                            uid:
                                description: UID contains the uid of the user that created the CertificateRequest. Populated by the cert-manager webhook on creation and immutable.
                                type: string
                            usages:
                                description: Usages is the set of x509 usages that are requested for the certificate. Defaults to `digital signature` and `key encipherment` if not specified.
                                items:
                                    description: 'KeyUsage specifies valid usage contexts for keys. See: https://tools.ietf.org/html/rfc5280#section-4.2.1.3      https://tools.ietf.org/html/rfc5280#section-4.2.1.12 Valid KeyUsage values are as follows: "signing", "digital signature", "content commitment", "key encipherment", "key agreement", "data encipherment", "cert sign", "crl sign", "encipher only", "decipher only", "any", "server auth", "client auth", "code signing", "email protection", "s/mime", "ipsec end system", "ipsec tunnel", "ipsec user", "timestamping", "ocsp signing", "microsoft sgc", "netscape sgc"'
                                    enum:
                                        - signing
                                        - digital signature
                                        - content commitment
                                        - key encipherment
                                        - key agreement
                                        - data encipherment
                                        - cert sign
                                        - crl sign
                                        - encipher only
                                        - decipher only
                                        - any
                                        - server auth
                                        - client auth
                                        - code signing
                                        - email protection
                                        - s/mime
                                        - ipsec end system
                                        - ipsec tunnel
                                        - ipsec user
                                        - timestamping
                                        - ocsp signing
                                        - microsoft sgc
                                        - netscape sgc
                                    type: string
                                type: array
                            username:
                                description: Username contains the name of the user that created the CertificateRequest. Populated by the cert-manager webhook on creation and immutable.
                                type: string
                        required:
                            - issuerRef
                            - request
                        type: object
                    status:
                        description: Status of the CertificateRequest. This is set and managed automatically.
                        properties:
                            ca:
                                description: The PEM encoded x509 certificate of the signer, also known as the CA (Certificate Authority). This is set on a best-effort basis by different issuers. If not set, the CA is assumed to be unknown/not available.
                                format: byte
                                type: string
                            certificate:
                                description: The PEM encoded x509 certificate resulting from the certificate signing request. If not set, the CertificateRequest has either not been completed or has failed. More information on failure can be found by checking the `conditions` field.
                                format: byte
                                type: string
                            conditions:
                                description: List of status conditions to indicate the status of a CertificateRequest. Known condition types are `Ready` and `InvalidRequest`.
                                items:
                                    description: CertificateRequestCondition contains condition information for a CertificateRequest.
                                    properties:
                                        lastTransitionTime:
                                            description: LastTransitionTime is the timestamp corresponding to the last status change of this condition.
                                            format: date-time
                                            type: string
                                        message:
                                            description: Message is a human readable description of the details of the last transition, complementing reason.
                                            type: string
                                        reason:
                                            description: Reason is a brief machine readable explanation for the condition's last transition.
                                            type: string
                                        status:
                                            description: Status of the condition, one of (`True`, `False`, `Unknown`).
                                            enum:
                                                - "True"
                                                - "False"
                                                - Unknown
                                            type: string
                                        type:
                                            description: Type of the condition, known values are (`Ready`, `InvalidRequest`, `Approved`, `Denied`).
                                            type: string
                                    required:
                                        - status
                                        - type
                                    type: object
                                type: array
                            failureTime:
                                description: FailureTime stores the time that this CertificateRequest failed. This is used to influence garbage collection and back-off.
                                format: date-time
                                type: string
                        type: object
                required:
                    - spec
                type: object
          served: true
          storage: false
          subresources:
            status: {}
        - additionalPrinterColumns:
            - jsonPath: .status.conditions[?(@.type=="Approved")].status
              name: Approved
              type: string
            - jsonPath: .status.conditions[?(@.type=="Denied")].status
              name: Denied
              type: string
            - jsonPath: .status.conditions[?(@.type=="Ready")].status
              name: Ready
              type: string
            - jsonPath: .spec.issuerRef.name
              name: Issuer
              type: string
            - jsonPath: .spec.username
              name: Requestor
              type: string
            - jsonPath: .status.conditions[?(@.type=="Ready")].message
              name: Status
              priority: 1
              type: string
            - description: CreationTimestamp is a timestamp representing the server time when this object was created. It is not guaranteed to be set in happens-before order across separate operations. Clients may not set this value. It is represented in RFC3339 form and is in UTC.
              jsonPath: .metadata.creationTimestamp
              name: Age
              type: date
          name: v1
          schema:
            openAPIV3Schema:
                description: "A CertificateRequest is used to request a signed certificate from one of the configured issuers. \n All fields within the CertificateRequest's `spec` are immutable after creation. A CertificateRequest will either succeed or fail, as denoted by its `status.state` field. \n A CertificateRequest is a one-shot resource, meaning it represents a single point in time request for a certificate and cannot be re-used."
                properties:
                    apiVersion:
                        description: 'APIVersion defines the versioned schema of this representation of an object. Servers should convert recognized schemas to the latest internal value, and may reject unrecognized values. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources'
                        type: string
                    kind:
                        description: 'Kind is a string value representing the REST resource this object represents. Servers may infer this from the endpoint the client submits requests to. Cannot be updated. In CamelCase. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds'
                        type: string
                    metadata:
                        type: object
                    spec:
                        description: Desired state of the CertificateRequest resource.
                        properties:
                            duration:
                                description: The requested 'duration' (i.e. lifetime) of the Certificate. This option may be ignored/overridden by some issuer types.
                                type: string
                            extra:
                                additionalProperties:
                                    items:
                                        type: string
                                    type: array
                                description: Extra contains extra attributes of the user that created the CertificateRequest. Populated by the cert-manager webhook on creation and immutable.
                                type: object
                            groups:
                                description: Groups contains group membership of the user that created the CertificateRequest. Populated by the cert-manager webhook on creation and immutable.
                                items:
                                    type: string
                                type: array
                                x-kubernetes-list-type: atomic
                            isCA:
                                description: IsCA will request to mark the certificate as valid for certificate signing when submitting to the issuer. This will automatically add the `cert sign` usage to the list of `usages`.
                                type: boolean
                            issuerRef:
                                description: IssuerRef is a reference to the issuer for this CertificateRequest.  If the `kind` field is not set, or set to `Issuer`, an Issuer resource with the given name in the same namespace as the CertificateRequest will be used.  If the `kind` field is set to `ClusterIssuer`, a ClusterIssuer with the provided name will be used. The `name` field in this stanza is required at all times. The group field refers to the API group of the issuer which defaults to `cert-manager.io` if empty.
                                properties:
                                    group:
                                        description: Group of the resource being referred to.
                                        type: string
                                    kind:
                                        description: Kind of the resource being referred to.
                                        type: string
                                    name:
                                        description: Name of the resource being referred to.
                                        type: string
                                required:
                                    - name
                                type: object
                            request:
                                description: The PEM-encoded x509 certificate signing request to be submitted to the CA for signing.
                                format: byte
                                type: string
                            uid:
                                description: UID contains the uid of the user that created the CertificateRequest. Populated by the cert-manager webhook on creation and immutable.
                                type: string
                            usages:
                                description: Usages is the set of x509 usages that are requested for the certificate. If usages are set they SHOULD be encoded inside the CSR spec Defaults to `digital signature` and `key encipherment` if not specified.
                                items:
                                    description: 'KeyUsage specifies valid usage contexts for keys. See: https://tools.ietf.org/html/rfc5280#section-4.2.1.3      https://tools.ietf.org/html/rfc5280#section-4.2.1.12 Valid KeyUsage values are as follows: "signing", "digital signature", "content commitment", "key encipherment", "key agreement", "data encipherment", "cert sign", "crl sign", "encipher only", "decipher only", "any", "server auth", "client auth", "code signing", "email protection", "s/mime", "ipsec end system", "ipsec tunnel", "ipsec user", "timestamping", "ocsp signing", "microsoft sgc", "netscape sgc"'
                                    enum:
                                        - signing
                                        - digital signature
                                        - content commitment
                                        - key encipherment
                                        - key agreement
                                        - data encipherment
                                        - cert sign
                                        - crl sign
                                        - encipher only
                                        - decipher only
                                        - any
                                        - server auth
                                        - client auth
                                        - code signing
                                        - email protection
                                        - s/mime
                                        - ipsec end system
                                        - ipsec tunnel
                                        - ipsec user
                                        - timestamping
                                        - ocsp signing
                                        - microsoft sgc
                                        - netscape sgc
                                    type: string
                                type: array
                            username:
                                description: Username contains the name of the user that created the CertificateRequest. Populated by the cert-manager webhook on creation and immutable.
                                type: string
                        required:
                            - issuerRef
                            - request
                        type: object
                    status:
                        description: Status of the CertificateRequest. This is set and managed automatically.
                        properties:
                            ca:
                                description: The PEM encoded x509 certificate of the signer, also known as the CA (Certificate Authority). This is set on a best-effort basis by different issuers. If not set, the CA is assumed to be unknown/not available.
                                format: byte
                                type: string
                            certificate:
                                description: The PEM encoded x509 certificate resulting from the certificate signing request. If not set, the CertificateRequest has either not been completed or has failed. More information on failure can be found by checking the `conditions` field.
                                format: byte
                                type: string
                            conditions:
                                description: List of status conditions to indicate the status of a CertificateRequest. Known condition types are `Ready` and `InvalidRequest`.
                                items:
                                    description: CertificateRequestCondition contains condition information for a CertificateRequest.
                                    properties:
                                        lastTransitionTime:
                                            description: LastTransitionTime is the timestamp corresponding to the last status change of this condition.
                                            format: date-time
                                            type: string
                                        message:
                                            description: Message is a human readable description of the details of the last transition, complementing reason.
                                            type: string
                                        reason:
                                            description: Reason is a brief machine readable explanation for the condition's last transition.
                                            type: string
                                        status:
                                            description: Status of the condition, one of (`True`, `False`, `Unknown`).
                                            enum:
                                                - "True"
                                                - "False"
                                                - Unknown
                                            type: string
                                        type:
                                            description: Type of the condition, known values are (`Ready`, `InvalidRequest`, `Approved`, `Denied`).
                                            type: string
                                    required:
                                        - status
                                        - type
                                    type: object
                                type: array
                            failureTime:
                                description: FailureTime stores the time that this CertificateRequest failed. This is used to influence garbage collection and back-off.
                                format: date-time
                                type: string
                        type: object
                required:
                    - spec
                type: object
          served: true
          storage: true
          subresources:
            status: {}
