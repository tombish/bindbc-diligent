/*
 *  Copyright 2021 Thomas Bishop
 *  Distributed under the Boost Software License, Version 1.0
 *  See accompanying file LICENSE or https://www.boost.org/LICENSE_1_0.txt
 */
 
/*
 *  Copyright 2019-2021 Diligent Graphics LLC
 *  Copyright 2015-2019 Egor Yusov
 *  
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *  
 *      http://www.apache.org/licenses/LICENSE-2.0
 *  
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 *
 *  In no event and under no legal theory, whether in tort (including negligence), 
 *  contract, or otherwise, unless required by applicable law (such as deliberate 
 *  and grossly negligent acts) or agreed to in writing, shall any Contributor be
 *  liable for any damages, including any direct, indirect, special, incidental, 
 *  or consequential damages of any character arising as a result of this License or 
 *  out of the use or inability to use the software (including but not limited to damages 
 *  for loss of goodwill, work stoppage, computer failure or malfunction, or any and 
 *  all other commercial damages or losses), even if such Contributor has been advised 
 *  of the possibility of such damages.
 */

module bindbc.diligent.graphics.query;

/// \file
/// Defines Diligent::IQuery interface and related data structures

public import bindbc.diligent.graphics.deviceobject;
public import bindbc.diligent.graphics.graphicstypes;

// {70F2A88A-F8BE-4901-8F05-2F72FA695BA0}
static const INTERFACE_ID IID_Query =
    INTERFACE_ID(0x70f2a88a, 0xf8be, 0x4901, [0x8f, 0x5, 0x2f, 0x72, 0xfa, 0x69, 0x5b, 0xa0]);

/// Occlusion query data.
/// This structure is filled by IQuery::GetData() for Diligent::QUERY_TYPE_OCCLUSION query type.
struct QueryDataOcclusion
{
    /// Query type - must be Diligent::QUERY_TYPE_OCCLUSION
    const QUERY_TYPE Type = QUERY_TYPE.QUERY_TYPE_OCCLUSION;

    /// The number of samples that passed the depth and stencil tests in between
    /// IDeviceContext::BeginQuery and IDeviceContext::EndQuery.
    ulong NumSamples = 0;
}

/// Binary occlusion query data.
/// This structure is filled by IQuery::GetData() for Diligent::QUERY_TYPE_BINARY_OCCLUSION query type.
struct QueryDataBinaryOcclusion
{
    /// Query type - must be Diligent::QUERY_TYPE_BINARY_OCCLUSION
    const QUERY_TYPE Type  = QUERY_TYPE.QUERY_TYPE_BINARY_OCCLUSION;

    /// Indicates if at least one sample passed depth and stencil testing in between
    /// IDeviceContext::BeginQuery and IDeviceContext::EndQuery.
    bool AnySamplePassed = 0;
}

/// Timestamp query data.
/// This structure is filled by IQuery::GetData() for Diligent::QUERY_TYPE_TIMESTAMP query type.
struct QueryDataTimestamp
{
    /// Query type - must be Diligent::QUERY_TYPE_TIMESTAMP
    const QUERY_TYPE Type = QUERY_TYPE.QUERY_TYPE_TIMESTAMP;

    /// The value of a high-frequency counter.
    ulong Counter = 0;

    /// The counter frequency, in Hz (ticks/second). If there was an error
    /// while getting the timestamp, this value will be 0.
    ulong Frequency = 0;
}

/// Pipeline statistics query data.
/// This structure is filled by IQuery::GetData() for Diligent::QUERY_TYPE_PIPELINE_STATISTICS query type.
///
/// \warning  In OpenGL backend the only field that will be populated is ClippingInvocations.
struct QueryDataPipelineStatistics
{
    /// Query type - must be Diligent::QUERY_TYPE_PIPELINE_STATISTICS
    const QUERY_TYPE Type = QUERY_TYPE.QUERY_TYPE_PIPELINE_STATISTICS;

    /// Number of vertices processed by the input assembler stage.
    ulong InputVertices = 0;

    /// Number of primitives processed by the input assembler stage.
    ulong InputPrimitives = 0;

    /// Number of primitives output by a geometry shader.
    ulong GSPrimitives = 0;

    /// Number of primitives that were sent to the clipping stage.
    ulong ClippingInvocations = 0;

    /// Number of primitives that were output by the clipping stage and were rendered.
    /// This may be larger or smaller than ClippingInvocations because after a primitive is
    /// clipped sometimes it is either broken up into more than one primitive or completely culled.
    ulong ClippingPrimitives = 0;

    /// Number of times a vertex shader was invoked.
    ulong VSInvocations = 0;

    /// Number of times a geometry shader was invoked.
    ulong GSInvocations = 0;

    /// Number of times a pixel shader shader was invoked.
    ulong PSInvocations = 0;

    /// Number of times a hull shader shader was invoked.
    ulong HSInvocations = 0;

    /// Number of times a domain shader shader was invoked.
    ulong DSInvocations = 0;

    /// Number of times a compute shader was invoked.
    ulong CSInvocations = 0;
}

/// Duration query data.
/// This structure is filled by IQuery::GetData() for Diligent::QUERY_TYPE_DURATION query type.
struct QueryDataDuration
{
    /// Query type - must be Diligent::QUERY_TYPE_DURATION
    const QUERY_TYPE Type = QUERY_TYPE.QUERY_TYPE_DURATION;

    /// The number of high-frequency counter ticks between
    /// BeginQuery and EndQuery calls.
    ulong Duration = 0;

    /// The counter frequency, in Hz (ticks/second). If there was an error
    /// while getting the timestamp, this value will be 0.
    ulong Frequency = 0;
}

/// Query description.
struct QueryDesc
{
    DeviceObjectAttribs _DeviceObjectAttribs;

    /// Query type, see Diligent::QUERY_TYPE.
    QUERY_TYPE Type = QUERY_TYPE.QUERY_TYPE_UNDEFINED;
}

/// Query interface.

/// Defines the methods to manipulate a Query object
struct IQueryMethods
{
    /// Gets the query data.

    /// \param [in] pData          - Pointer to the query data structure. Depending on the type of the query,
    ///                              this must be the pointer to Diligent::QueryDataOcclusion, Diligent::QueryDataBinaryOcclusion,
    ///                              Diligent::QueryDataTimestamp, or Diligent::QueryDataPipelineStatistics
    ///                              structure.
    ///                              An application may provide nullptr to only check the query status.
    /// \param [in] DataSize       - Size of the data structure.
    /// \param [in] AutoInvalidate - Whether to invalidate the query if the results are available and release associated resources.
    ///                              An application should typically always invalidate completed queries unless
    ///                              it needs to retrieve the same data through GetData() multiple times.
    ///                              A query will not be invalidated if pData is nullptr.
    ///
    /// \return     true if the query data is available and false otherwise.
    ///
    /// \note       In Direct3D11 backend timestamp queries will only be available after FinishFrame is called
    ///             for the frame in which they were collected.
    ///
    ///             If AutoInvalidate is set to true, and the data have been retrieved, an application
    ///             must not call GetData() until it begins and ends the query again.
    bool* GetData(IQuery*,
                         void*  pData,
                         uint   DataSize, 
                         bool   AutoInvalidate = true);

    /// Invalidates the query and releases associated resources.
    void* Invalidate(IQuery*);
}

struct IQueryVtbl { IQueryMethods Query; }
struct IQuery { IQueryVtbl* pVtbl; }

const(QueryDesc)* IQuery_GetDesc(IQuery* object) {
    return cast(const(QueryDesc)*)IDeviceObject_GetDesc(cast(IDeviceObject*)object);
}

bool* IQuery_GetData(IQuery* query,
                         void*  pData,
                         uint   dataSize, 
                         bool   autoInvalidate = true) {
    return query.pVtbl.Query.GetData(query, pData, dataSize, autoInvalidate);
}

void* IQuery_Invalidate(IQuery* query) {
    return query.pVtbl.Query.Invalidate(query);
}