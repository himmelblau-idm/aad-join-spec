<style>
body {
  font-family: Segoe UI,SegoeUI,Helvetica Neue,Helvetica,Arial,sans-serif;
  padding: 1em;
  margin: auto;
  max-width: 42em;
  background: #fefefe;
}
.protocol-table p {
  margin-top: 0px;
}
p {
  margin-top: 1rem;
  margin-bottom: 0px;
}
table {
  margin-top: 1rem;
  border: 1px solid #EAEAEA;
  border-collapse: collapse;
  width: 100%;
}
table, th, td {
  border-radius: 3px;
  padding: 5px;
}
th, td {
  font-size: .875rem;
  padding-top: 0.5rem;
  padding-bottom: 0.5rem;
  border: 1px solid #bbb;
  color: #2a2a2a;
}
th {
  background-color: #ededed;
  font-weight: 600;
}
td {
  padding: 0.5rem;
  background-color: #fff;
}
h1, h2, h3, h4, h5, h6 {
  font-weight: bold;
  color: #000;
}
h1 {
  font-size: 28px;
}
h2 {
  font-size: 24px;
}
h3 {
  font-size: 18px;
}
h4 {
  font-size: 16px;
}
h5 {
  font-size: 14px;
}
</style>

# [MS-DRS] Device Registration Service

Specifies the Device Registration Join Protocol, which establishes a device
identity between the physical device and an Entra ID (Azure AD) tenant.

## Published Version

<table class="protocol-table"><thead>
  <tr>
   <th>
   <p>Date</p>
   </th>
   <th>
   <p>Protocol Revision</p>
   </th>
   <th>
   <p>Revision Class</p>
   </th>
   <th>
   <p>Downloads</p>
   </th>
  </tr>
 </thead><tbody>
 <tr>
  <td>
  <p>10/12/2023</p>
  </td>
  <td>
  <p>0.01</p>
  </td>
  <td>
  <p>New</p>
  </td>
  <td>
  <p>

  </p>
  </td>
 </tr>
 <tr>
  <td>
  <p>01/26/2024</p>
  </td>
  <td>
  <p>0.02</p>
  </td>
  <td>
  <p>Minor</p>
  </td>
  <td>
  <p>
    <span><a href="https://github.com/himmelblau-idm/aad-join-spec/releases/download/0.02/aad-join-spec.pdf" data-linktype="external">PDF</a></span>
  | <span><a href="https://github.com/himmelblau-idm/aad-join-spec/releases/download/0.02/aad-join-spec.html" data-linktype="external">HTML</a></span>
  </p>
  </td>
 </tr>
</tbody></table>

# 1 Introduction

The Device Registration Join Protocol provides a lightweight mechanism for
registering personal or corporate-owned devices with an Entra ID tenant.

This protocol also defines the discovery of information needed to register
devices.

# 2 Protocol Details

## 2.1 Join Service Details

### 2.1.1 device

The following HTTP methods are allowed to be performed on this resource.

<table class="protocol-table"><thead>
  <tr>
   <th>
   <p>HTTP method</p>
   </th>
   <th>
   <p>Section</p>
   </th>
   <th>
   <p>Description</p>
   </th>
  </tr>
 </thead><tbody>
 <tr>
  <td>
  <p>POST</p>
  </td>
  <td>
  <p>2.1.1.1</p>
  </td>
  <td>
  <p>Create a new device object.</p>
  </td>
 </tr>
</tbody></table>

#### 2.1.1.1 POST

This method is transported by an HTTP POST.

The method can be invoked through either the JoinEndpoint URI or the
PrecreateEndpoint URI (if specifying a PreAuthorizedJoinChallenge) discovered
via the
[Device Registration Discovery Service](#device-registration-discovery-response).

##### 2.1.1.1.1 <a id="device-request-body"></a> Request Body

The request body contains the following JSON-formatted object.

<pre class="has-inner-focus">
<code class="lang-json">{
    "CertificateRequest": {
        "Type": string,
        "Data": string
    },
    "TransportKey": string,
    "TargetDomain": string,
    "DeviceType": string,
    "OSVersion": string,
    "DeviceDisplayName": string,
    "JoinType": number,
    "AikCertificate": string,
    "AttestationData": string,
    "Attributes": {
        "ReuseDevice": true|false,
        "SharedDevice": true|false
    },
    "PreAuthorizedJoinChallenge": string
}
</code></pre>

__CertificateRequest__: A property with the following fields:

- __Type__: A property that MUST contain "pkcs10". Required.

- __Data__: A property that contains a base64-encoded
[PKCS#10](https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-dvrj/6961b602-0255-438a-8e64-1ee6081d9b88#gt_30428780-593d-43f8-b187-58f64d2eae7d)
certificate request
[[RFC4211]](https://go.microsoft.com/fwlink/?LinkId=301568). The certificate
request MUST use an
[RSA](https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-dvrj/6961b602-0255-438a-8e64-1ee6081d9b88#gt_3f85a24a-f32a-4322-9e99-eba6ae802cd6)
[public key algorithm](https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-dvrj/6961b602-0255-438a-8e64-1ee6081d9b88#gt_46ef9374-f1be-4b5c-8389-489d594c7603)
[[RFC8017]](https://go.microsoft.com/fwlink/?linkid=2164409) with a 2048-bit
key, a SHA256WithRSAEncryption signature algorithm, and a SHA256 hash algorithm.
The Certificate request SHOULD incorporate a Nonce extension as received from a
[Nonce Service Request](#nonce-service). The CN of the request MUST equal
`7E980AD9-B86D-4306-9425-9AC066FB014A`. Required.

    - The OID for the Nonce extension is defined as
"1.2.840.113556.1.5.284.2.1".

__TransportKey__: The base64-encoded public portion of an asymmetric key that is
generated by the client. This is a BCRYPT_RSAKEY_BLOB, as defined in the
[Microsoft Security and Identity documentation](https://learn.microsoft.com/en-us/windows/win32/api/bcrypt/ns-bcrypt-bcrypt_rsakey_blob).
Required.

The BCRYPT_RSAKEY_BLOB MUST conform to the following specifications:

<pre class="has-inner-focus">
<code class="lang-c">struct BCRYPT_RSAKEY_BLOB {
    uint32 Magic = b"RSA1";
    uint32 BitLength;
    uint32 cbPublicExpLength;
    uint32 cbModulusLength;
    uint32 cbPrime1Length = 0;
    uint32 cbPrime2Length = 0;
    uint8* cbPublicExp;
    uint8* cbModulus;
    uint8* cbPrime1 = NULL;
    uint8* cbPrime2 = NULL;
}
</code></pre>

While Microsoft reserves place holders for cbPrime1Length and cbPrime2Length,
Azure does not support the specification of cbPrime1 and cbPrime2 in the actual
blob. cbPrime1Length and cbPrime2Length MUST be set to 0. cbPrime1
and cbPrime2 MUST be empty.

__TargetDomain__: The fully qualified host name of the device registration
service. Required.

__DeviceType__: The operating system type installed on the device. Required.

__OSVersion__: The operating system version installed on the device. Required.

__DeviceDisplayName__: The friendly name of the device. Required.

__JoinType__: The type of join operation. The value is set as defined below.
Required.

<table class="protocol-table"><thead>

  <tr>
   <th>
   <p>JoinType</p>
   </th>
   <th>
   <p>Description</p>
   </th>
  </tr>
 </thead><tbody>
 <tr>
  <td>
  <p>0</p>
  </td>
  <td>
  <p>Azure AD join.</p>
  </td>
 </tr>
 <tr>
  <td>
  <p>3</p>
  </td>
  <td>
  <p>Unknown.</p>
  </td>
 </tr>
 <tr>
  <td>
  <p>4</p>
  </td>
  <td>
  <p>Azure AD register.</p>
  </td>
 </tr>
 <tr>
  <td>
  <p>6</p>
  </td>
  <td>
  <p>Azure AD hybrid join.</p>
  </td>
 </tr>
 <tr>
  <td>
  <p>8</p>
  </td>
  <td>
  <p>Azure AD join.</p>
  </td>
 </tr>
</tbody></table>

__AikCertificate__: [Attestation Identity Key Certificate](https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-wcce/adc2aab5-701b-4f91-9dc0-5615543712bf). Optional.

__AttestationData__: An exported [TPMS_ATTEST structure](https://trustedcomputinggroup.org/wp-content/uploads/TCG_TPM2_r1p59_Part2_Structures_pub.pdf). Optional.

__Attributes__: A property with the following fields:

- __ReuseDevice__: This device object may be reused. Optional.

- __SharedDevice__: This device is a shared device. Optional.

- __ReturnClientSid__: Whether to include the MembershipChanges field in the
response. Optional.

__PreAuthorizedJoinChallenge__: A [JSON Web Token (JWT)](https://datatracker.ietf.org/doc/html/rfc7519).
If this attribute is specified, then the join request MUST be submitted to the
PrecreateEndpoint URI. Optional.

##### 2.1.1.1.2 <a id="device-response-body"></a> Response Body

If the DRS server successfully creates a device object in the directory, an
HTTP 200 status code is returned. Additionally, the response body for the POST
response contains a JSON-formatted object, as defined below. See section
[2.1.1.1.3](#device-processing-details) for processing details.

<pre class="has-inner-focus">
<code class="lang-json">{
    "Certificate": {
        "Thumbprint": string,
        "RawBody": string
    },
    "User": {
        "Upn": string
    },
    "MembershipChanges": [
        {
            "LocalSID": string,
            "AddSIDs": string array,
        }
    ]
}
</code></pre>

__Certificate__: A property with the following fields.

- __Thumbprint__: The SHA1 hash of the certificate
[thumbprint](https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-dvrj/6961b602-0255-438a-8e64-1ee6081d9b88#gt_a8d3bb6c-a2e2-44ae-ba3b-58ca861ab74f).

- __RawBody__: An X.509 certificate signed by the DRS server as a base64-encoded
string [[RFC4648]](https://go.microsoft.com/fwlink/?LinkId=90487).

__User__: A property with the following fields.

- __Upn__: The identifier of the identity that authenticated to the Web service,
or the registered owner of the device.

__MembershipChanges__: An array with the following fields.

- __LocalSID__: The [security identifier (SID)](https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-dvrj/6961b602-0255-438a-8e64-1ee6081d9b88#gt_83f2020d-0804-4840-a5ac-e06439d50f8d)
of the directory administrator account. This value MUST be ignored by the
client.

- __AddSIDs__: An array of sids. This value MUST be ignored by the client.

##### 2.1.1.1.3 <a id="device-processing-details"></a> Processing Details

# 3 Protocol Examples

## 3.1 Device Registration Discovery Service

Discover the list of available enrollment URLs and api versions.

### HTTP Request

You can address the tenant using either the __tenantId__ or __domain name__.

<pre class="has-inner-focus">
<code class="lang-http"><span>GET /{tenantId}/Discover?api-version=1.9
GET /{domainName}/Discover?api-version=1.9
</span></code></pre>

### Request Headers

<table class="protocol-table"><thead>
  <tr>
   <th>
   <p>Name</p>
   </th>
   <th>
   <p>Description</p>
   </th>
  </tr>
 </thead><tbody>
 <tr>
  <td>
  <p>Content-type</p>
  </td>
  <td>
  <p>application/json</p>
  </td>
 </tr>
 <tr>
  <td>
  <p>ocp-adrs-client-name</p>
  </td>
  <td>
  <p>The name of the client application making the request.</p>
  </td>
 </tr>
 <tr>
  <td>
  <p>ocp-adrs-client-version</p>
  </td>
  <td>
  <p>The software version of the client application making the request.</p>
  </td>
 </tr>
</tbody></table>

### Request body

Do not supply a request body for this method.

### Response

If successful, this method returns a 200 OK response code and a list of
enrollment services in the response body.

### Example

#### Request

The following is an example of the request.

<pre class="has-inner-focus">
<code class="lang-http"><span>GET https://enterpriseregistration.windows.net/{tenantId}/Discover?api-version=1.9
</span></code></pre>

#### <a id="device-registration-discovery-response"></a> Response

The following is an example of the response.

<pre class="has-inner-focus">
<code class="lang-json">HTTP/1.1 200 OK
Content-type: application/json

{
    "DiscoveryService": {
        "DiscoveryEndpoint": "https://{registrationServer}/{tenantId}/Discover",
        "ServiceVersion": "1.9"
    },
    "DeviceRegistrationService": {
        "RegistrationEndpoint": "https://{registrationServer}/EnrollmentServer/DeviceEnrollmentWebService.svc",
        "RegistrationResourceId": "urn:ms-drs:{registrationServer}",
        "ServiceVersion": "1.0"
    },
    "AuthenticationService": {
        "OAuth2": {
            "AuthCodeEndpoint": "https://{authServer}/{tenantId}/oauth2/authorize",
            "TokenEndpoint": "https://{authServer}/{tenantId}/oauth2/token"
        }
    },
    "IdentityProviderService": {
        "Federated": false,
        "PassiveAuthEndpoint": "https://{authServer}/{tenantId}/wsfed"
    },
    "DeviceJoinService": {
        "JoinEndpoint": "https://{registrationServer}/EnrollmentServer/device/",
        "JoinResourceId": "urn:ms-drs:{registrationServer}",
        "ServiceVersion": "2.0"
    },
    "KeyProvisioningService": {
        "KeyProvisionEndpoint": "https://{registrationServer}/EnrollmentServer/key/",
        "KeyProvisionResourceId": "urn:ms-drs:{registrationServer}",
        "ServiceVersion": "1.0"
    },
    "WebAuthNService": {
        "ServiceVersion": "1.0",
        "WebAuthNEndpoint": "https://{registrationServer}/webauthn/{tenantId}/",
        "WebAuthNResourceId": "urn:ms-drs:{registrationServer}"
    },
    "DeviceManagementService": {
        "DeviceManagementEndpoint": "https://{registrationServer}/manage/{tenantId}/",
        "DeviceManagementResourceId": "urn:ms-drs:{registrationServer}",
        "ServiceVersion": "1.0"
    },
    "MsaProviderData": {
        "SiteId": "{siteId}",
        "SiteUrl": "{registrationServer}"
    },
    "PrecreateService": {
        "PrecreateEndpoint": "https://{registrationServer}/EnrollmentServer/device/precreate/{tenantId}/",
        "PrecreateResourceId": "urn:ms-drs:{registrationServer}",
        "ServiceVersion": "2.0"
    },
    "TenantInfo": {
        "DisplayName": "{tenantName}",
        "TenantId": "{tenantId}",
        "TenantName": "{domainName}"
    },
    "AzureRbacService": {
        "RbacPolicyEndpoint": "https://pas.windows.net"
    },
    "BPLService": {
        "BPLProxyServicePrincipalId": "{UUID}",
        "BPLResourceId": "urn:ms-drs:{registrationServer}",
        "BPLServiceEndpoint": "https://{registrationServer}/aadpasswordpolicy/{tenantId}/",
        "ServiceVersion": "1.0"
    },
    "DeviceJoinResourceService": {
        "Endpoint": "https://{registrationServer}/EnrollmentServer/device/resource/{tenantId}/",
        "ResourceId": "urn:ms-drs:{registrationServer}",
        "ServiceVersion": "2.0"
    },
    "NonceService": {
        "Endpoint": "https://{registrationServer}/EnrollmentServer/nonce/{tenantId}/",
        "ResourceId": "urn:ms-drs:{registrationServer}",
        "ServiceVersion": "1.0"
    }
}
</code></pre>

## 3.2 Nonce Service

The Nonce Service is used to request a nonce (__n__umber __once__) for crafting
join requests.

### HTTP request

A nonce request is sent using the Nonce Service endpoint and ServiceVersion
discovered during discovery in section
[4.2.1](#device-registration-discovery-server-response).

You can address the tenant using either the __tenantId__ or __domain name__.

<pre class="has-inner-focus">
<code class="lang-http"><span>GET /EnrollmentServer/nonce/{tenantId}/?api-version=1.0
GET /EnrollmentServer/nonce/{domainName}/?api-version=1.0
</span></code></pre>

### Request Headers

None.

### Response

If successful, this method returns a 200 OK response code and a nonce value in
the response body.

### Example

#### Request

The following is an example of the request.

<pre class="has-inner-focus">
<code class="lang-http"><span>GET https://enterpriseregistration.windows.net/EnrollmentServer/nonce/{tenantId}/?api-version=1.0
</span></code></pre>

#### Response

The following is an example of the response.

<blockquote>
<strong>Note:</strong> The response object shown here is shortened for
readability.
</blockquote>

<pre class="has-inner-focus">
<code class="lang-json">HTTP/1.1 200 OK
Content-type: application/json

{
    "ReponseStatus": {
        "message": "Successfully created a nonce",
        "traceId": "c532f6ca-259a-44af-8720-1f901ec69a09",
        "time": "10/12/2023 3:05:30 PM"
    },
    "Value": "ZXlKaGJHY2lPaUpTVTBFdFQwRkZVQzB5TlRZaUxDSmxibU1pT2lKQk1qVTJSME5OS
              {...}
              ENGV1aS15WlJ4OVdDN1hhc0RrTXA4SWUyUC5KM0hoSXlUWjRDNU1La3kzZklSc253"
}
</code></pre>

## 3.3 Device Join Service

The purpose of the Device Join Service is to enroll a device in the directory.

### HTTP Request

The device join request is sent using the Device Join Service endpoint and
ServiceVersion discovered during discovery in section
[3.2.1](#device-registration-discovery-server-response).

This method is transported by an HTTP POST.

The method can be invoked through the following URI:

<pre class="has-inner-focus">
<code class="lang-http"><span>POST /EnrollmentServer/device/?api-version=2.0
</span></code></pre>

### Request headers

<table class="protocol-table"><thead>

  <tr>
   <th>
   <p>Name</p>
   </th>
   <th>
   <p>Description</p>
   </th>
  </tr>
 </thead><tbody>
 <tr>
  <td>
  <p>Authorization</p>
  </td>
  <td>
  <p>Bearer {token}. Required.</p>
  </td>
 </tr>
 <tr>
  <td>
  <p>Content-type</p>
  </td>
  <td>
  <p>application/json</p>
  </td>
 </tr>
 <tr>
  <td>
  <p>client-request-id</p>
  </td>
  <td>
  <p>A correlation Id. Optional.</p>
  </td>
 </tr>
 <tr>
  <td>
  <p>ocp-adrs-client-name</p>
  </td>
  <td>
  <p>The name of the client application making the request.</p>
  </td>
 </tr>
 <tr>
  <td>
  <p>ocp-adrs-client-version</p>
  </td>
  <td>
  <p>The software version of the client application making the request.</p>
  </td>
 </tr>
</tbody></table>

The authorization token must be granted via a PublicClientApplication using the
Microsoft Authentication Broker application while requesting
access to the Device Registration Service application resource.

<table class="protocol-table"><thead>

  <tr>
   <th>
   <p>Application ID</p>
   </th>
   <th>
   <p>Description</p>
   </th>
  </tr>
 </thead><tbody>
 <tr>
  <td>
  <p>29d9ed98-a469-4536-ade2-f981bc1d605e</p>
  </td>
  <td>
  <p>Microsoft Authentication Broker Application Id</p>
  </td>
 </tr>
 <tr>
  <td>
  <p>01cb2876-7ebd-4aa4-9cc9-d28bd4d359a9</p>
  </td>
  <td>
  <p>Device Registration Service Application Id</p>
  </td>
 </tr>
</tbody></table>

### Request body

In the request body, supply a JSON representation of a device registration join
request, as specified in [section 2.1.1.1.1](#device-request-body).

### Response

If successful, this method returns 201 Created response code and a signed
certificate in the response body, as specified in
[section 2.1.1.1.2](#device-response-body).

### Example

The following example shows a request to the DRS server to create a device
object ([section 2.1.1.1.1](#device-request-body)) and the response
([section 2.1.1.1.2](#device-response-body)).

### Request

Here is an example of the request.

<blockquote>
<strong>Note:</strong> The request object shown here is shortened for
readability.
</blockquote>

<pre class="has-inner-focus">
<code class="lang-json">POST https://enterpriseregistration.windows.net/EnrollmentServer/device/?api-version=2.0
Content-type: application/json

{
  "CertificateRequest": {
    "Type": "pkcs10",
    "Data": "MIICd...LWH31"
  },
  "TransportKey": "UlNBM...G5Q==",
  "TargetDomain": "sts.contoso.com",
  "DeviceType": "Linux",
  "OSVersion": "openSUSE Leap 15.5",
  "DeviceDisplayName": "MyPC",
  "JoinType": 4
}
</code></pre>

### Response

Here is an example of the response.

<blockquote>
<strong>Note:</strong> The response object shown here is shortened for
readability.
</blockquote>

<pre class="has-inner-focus">
<code class="lang-json">HTTP/1.1 201 Created
Content-type: application/json

{
    "Certificate": {
        "Thumbprint": "D09A73223D16855752C5E820A70540BA6450103E",
        "RawBody": "MIID/...rQZE="
    },
    "User": { "Upn": "myuser@contoso.com" },
    "MembershipChanges": [
        {
            "LocalSID": "S-1-5-32-544",
            "AddSIDs": [
                "S-1-12-1-3792446273-1182712816-3605559969-2553266617",
                "S-1-12-1-2927421837-1319477369-3754249106-3334640282"
            ]
        }
    ]
}
</code></pre>