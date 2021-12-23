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

module bindbc.diligent.graphics.pipelinestate;

/// \file
/// Definition of the Diligent::IRenderDevice interface and related data structures

public import bindbc.diligent.primitives.object;
//#include "../../../Platforms/interface/PlatformDefinitions.h"
import bindbc.diligent.graphics.graphicstypes;
import bindbc.diligent.graphics.blendstate;
import bindbc.diligent.graphics.rasterizerstate;
import bindbc.diligent.graphics.depthstencilstate;
import bindbc.diligent.graphics.inputlayout;
import bindbc.diligent.graphics.shaderresourcebinding;
import bindbc.diligent.graphics.shaderresourcevariable;
import bindbc.diligent.graphics.shader;
import bindbc.diligent.graphics.sampler;
import bindbc.diligent.graphics.renderpass;
import bindbc.diligent.graphics.pipelineresourcesignature;

    
/// Sample description

/// This structure is used by GraphicsPipelineDesc to describe multisampling parameters
struct SampleDesc
{
    /// Sample count
    ubyte Count     = 1;

    /// Quality
    ubyte Quality   = 0;
}

/// Shader variable property flags.
enum SHADER_VARIABLE_FLAGS : ubyte
{
    /// Shader variable has no special properties.
    SHADER_VARIABLE_FLAG_NONE               = 0x00,

    /// Indicates that dynamic buffers will never be bound to the resource
    /// variable. Applies to SHADER_RESOURCE_TYPE_CONSTANT_BUFFER,
    /// SHADER_RESOURCE_TYPE_BUFFER_UAV, SHADER_RESOURCE_TYPE_BUFFER_SRV resources.
    ///
    /// \remarks    This flag directly translates to the PIPELINE_RESOURCE_FLAG_NO_DYNAMIC_BUFFERS
    ///             flag in the internal pipeline resource signature.
    SHADER_VARIABLE_FLAG_NO_DYNAMIC_BUFFERS = 0x01,

    SHADER_VARIABLE_FLAG_LAST               = SHADER_VARIABLE_FLAG_NO_DYNAMIC_BUFFERS
}

/// Describes shader variable
struct ShaderResourceVariableDesc
{
    /// Shader stages this resources variable applies to. If more than one shader stage is specified,
    /// the variable will be shared between these stages. Shader stages used by different variables
    /// with the same name must not overlap.
    SHADER_TYPE                   ShaderStages = SHADER_TYPE.SHADER_TYPE_UNKNOWN;

    /// Shader variable name
    const(char)*                   Name        = null;

    /// Shader variable type. See Diligent::SHADER_RESOURCE_VARIABLE_TYPE for a list of allowed types
    SHADER_RESOURCE_VARIABLE_TYPE Type         = SHADER_RESOURCE_VARIABLE_TYPE.SHADER_RESOURCE_VARIABLE_TYPE_STATIC;

    SHADER_VARIABLE_FLAGS         Flags        = SHADER_VARIABLE_FLAGS.SHADER_VARIABLE_FLAG_NONE;
}

/// Pipeline layout description
struct PipelineResourceLayoutDesc
{
    /// Default shader resource variable type. This type will be used if shader
    /// variable description is not found in the Variables array
    /// or if Variables == nullptr
    SHADER_RESOURCE_VARIABLE_TYPE        DefaultVariableType        = SHADER_RESOURCE_VARIABLE_TYPE.SHADER_RESOURCE_VARIABLE_TYPE_STATIC;

    /// By default, all variables not found in the Variables array define separate resources.
    /// For example, if there is resource "g_Texture" in the vertex and pixel shader stages, there
    /// will be two separate resources in both stages. This member defines shader stages
    /// in which default variables will be combined.
    /// For example, if DefaultVariableMergeStages == SHADER_TYPE_VERTEX | SHADER_TYPE_PIXEL,
    /// then both resources in the example above will be combined into a single one.
    /// If there is another "g_Texture" in geometry shader, it will be separate from combined
    /// vertex-pixel "g_Texture".
    /// This memeber has no effect on variables defined in Variables array.
    SHADER_TYPE                          DefaultVariableMergeStages = SHADER_TYPE.SHADER_TYPE_UNKNOWN;

    /// Number of elements in Variables array            
    uint                                 NumVariables               = 0;

    /// Array of shader resource variable descriptions               

    /// There may be multiple variables with the same name that use different shader stages,
    /// but the stages must not overlap.
    const(ShaderResourceVariableDesc)*   Variables                  = null;
                                                            
    /// Number of immutable samplers in ImmutableSamplers array   
    uint                                 NumImmutableSamplers       = 0;
                                                            
    /// Array of immutable sampler descriptions                
    const(ImmutableSamplerDesc)*         ImmutableSamplers          = null;
}

/// Graphics pipeline state description

/// This structure describes the graphics pipeline state and is part of the GraphicsPipelineStateCreateInfo structure.
struct GraphicsPipelineDesc
{
    /// Blend state description.
    BlendStateDesc BlendDesc;

    /// 32-bit sample mask that determines which samples get updated 
    /// in all the active render targets. A sample mask is always applied; 
    /// it is independent of whether multisampling is enabled, and does not 
    /// depend on whether an application uses multisample render targets.
    uint SampleMask = 0xFFFFFFFF;

    /// Rasterizer state description.
    RasterizerStateDesc RasterizerDesc;

    /// Depth-stencil state description.
    DepthStencilStateDesc DepthStencilDesc;

    /// Input layout, ignored in a mesh pipeline.
    InputLayoutDesc InputLayout;
    //D3D12_INDEX_BUFFER_STRIP_CUT_VALUE IBStripCutValue;

    /// Primitive topology type, ignored in a mesh pipeline.
    PRIMITIVE_TOPOLOGY PrimitiveTopology = PRIMITIVE_TOPOLOGY.PRIMITIVE_TOPOLOGY_TRIANGLE_LIST;

    /// The number of viewports used by this pipeline
    ubyte NumViewports           = 1;

    /// The number of render targets in the RTVFormats array.
    /// Must be 0 when pRenderPass is not null.
    ubyte NumRenderTargets       = 0;

    /// When pRenderPass is not null, the subpass
    /// index within the render pass.
    /// When pRenderPass is null, this member must be 0.
    ubyte SubpassIndex           = 0;

    /// Render target formats.
    /// All formats must be TEX_FORMAT_UNKNOWN when pRenderPass is not null.
    TEXTURE_FORMAT[DILIGENT_MAX_RENDER_TARGETS] RTVFormats = TEXTURE_FORMAT.TEX_FORMAT_UNKNOWN;

    /// Depth-stencil format.
    /// Must be TEX_FORMAT_UNKNOWN when pRenderPass is not null.
    TEXTURE_FORMAT DSVFormat     = TEXTURE_FORMAT.TEX_FORMAT_UNKNOWN;

    /// Multisampling parameters.
    SampleDesc SmplDesc;

    /// Pointer to the render pass object.

    /// When non-null render pass is specified, NumRenderTargets must be 0,
    /// and all RTV formats as well as DSV format must be TEX_FORMAT_UNKNOWN.
    IRenderPass* pRenderPass     = null;

    /// Node mask.
    uint NodeMask = 0;

    //D3D12_CACHED_PIPELINE_STATE CachedPSO;
    //D3D12_PIPELINE_STATE_FLAGS Flags;
}

/// Ray tracing general shader group description
struct RayTracingGeneralShaderGroup
{
    /// Unique group name.
    const(char)* Name   = null;

    /// Shader type must be SHADER_TYPE_RAY_GEN, SHADER_TYPE_RAY_MISS or SHADER_TYPE_CALLABLE.
    IShader*    pShader = null;
}

/// Ray tracing triangle hit shader group description.
struct RayTracingTriangleHitShaderGroup
{
    /// Unique group name.
    const(char)* Name             = null;

    /// Closest hit shader.
    /// The shader type must be SHADER_TYPE_RAY_CLOSEST_HIT.
    IShader*    pClosestHitShader = null;

    /// Any-hit shader. Can be null.
    /// The shader type must be SHADER_TYPE_RAY_ANY_HIT.
    IShader*    pAnyHitShader     = null; // can be null
}

/// Ray tracing procedural hit shader group description.
struct RayTracingProceduralHitShaderGroup
{
    /// Unique group name.
    const(char)* Name               = null;

    /// Intersection shader.
    /// The shader type must be SHADER_TYPE_RAY_INTERSECTION.
    IShader*    pIntersectionShader = null;

    /// Closest hit shader. Can be null.
    /// The shader type must be SHADER_TYPE_RAY_CLOSEST_HIT.
    IShader*    pClosestHitShader   = null;

    /// Any-hit shader. Can be null.
    /// The shader type must be SHADER_TYPE_RAY_ANY_HIT.
    IShader*    pAnyHitShader       = null;
}

/// This structure describes the ray tracing pipeline state and is part of the RayTracingPipelineStateCreateInfo structure.
struct RayTracingPipelineDesc
{
    /// Size of the additional data passed to the shader.
    /// Shader record size plus shader group size (32 bytes) must be aligned to 32 bytes.
    /// Shader record size plus shader group size (32 bytes) must not exceed 4096 bytes.
    ushort  ShaderRecordSize   = 0;

    /// Number of recursive calls of TraceRay() in HLSL or traceRay() in GLSL.
    /// Zero means no tracing of rays at all, only ray-gen shader will be executed.
    /// See DeviceProperties::MaxRayTracingRecursionDepth.
    ubyte   MaxRecursionDepth  = 0;
}

/// Pipeline type
enum PIPELINE_TYPE : ubyte
{
    /// Graphics pipeline, which is used by IDeviceContext::Draw(), IDeviceContext::DrawIndexed(),
    /// IDeviceContext::DrawIndirect(), IDeviceContext::DrawIndexedIndirect().
    PIPELINE_TYPE_GRAPHICS,

    /// Compute pipeline, which is used by IDeviceContext::DispatchCompute(), IDeviceContext::DispatchComputeIndirect().
    PIPELINE_TYPE_COMPUTE,

    /// Mesh pipeline, which is used by IDeviceContext::DrawMesh(), IDeviceContext::DrawMeshIndirect().
    PIPELINE_TYPE_MESH,

    /// Ray tracing pipeline, which is used by IDeviceContext::TraceRays().
    PIPELINE_TYPE_RAY_TRACING,

    /// Tile pipeline, which is used by IDeviceContext::DispatchTile().
    PIPELINE_TYPE_TILE,

    PIPELINE_TYPE_LAST = PIPELINE_TYPE_TILE,

    PIPELINE_TYPE_INVALID = 0xFF
}

/// Pipeline state description
struct PipelineStateDesc
{
    DeviceObjectAttribs _DeviceObjectAttribs;

    /// Pipeline type
    PIPELINE_TYPE PipelineType    = PIPELINE_TYPE.PIPELINE_TYPE_GRAPHICS;

    /// Shader resource binding allocation granularity

    /// This member defines allocation granularity for internal resources required by the shader resource
    /// binding object instances.
    /// Has no effect if the PSO is created with explicit pipeline resource signature(s).
    uint SRBAllocationGranularity = 1;

    /// Defines which immediate contexts are allowed to execute commands that use this pipeline state.

    /// When ImmediateContextMask contains a bit at position n, the pipeline state may be
    /// used in the immediate context with index n directly (see DeviceContextDesc::ContextId).
    /// It may also be used in a command list recorded by a deferred context that will be executed
    /// through that immediate context.
    ///
    /// \remarks    Only specify these bits that will indicate those immediate contexts where the PSO
    ///             will actually be used. Do not set unncessary bits as this will result in extra overhead.
    ulong ImmediateContextMask    = 1;

    /// Pipeline layout description
    PipelineResourceLayoutDesc ResourceLayout;
}

/// Pipeline state creation flags
enum PSO_CREATE_FLAGS : uint
{
    /// Null flag.
    PSO_CREATE_FLAG_NONE                              = 0x00,

    /// Ignore missing variables.

    /// By default, the engine outputs a warning for every variable
    /// provided as part of the pipeline resource layout description
    /// that is not found in any of the designated shader stages.
    /// Use this flag to silence these warnings.
    PSO_CREATE_FLAG_IGNORE_MISSING_VARIABLES          = 0x01,

    /// Ignore missing immutable samplers.

    /// By default, the engine outputs a warning for every immutable sampler
    /// provided as part of the pipeline resource layout description
    /// that is not found in any of the designated shader stages.
    /// Use this flag to silence these warnings.
    PSO_CREATE_FLAG_IGNORE_MISSING_IMMUTABLE_SAMPLERS = 0x02,
}

/// Pipeline state creation attributes
struct PipelineStateCreateInfo
{
    /// Pipeline state description
    PipelineStateDesc PSODesc;

    /// Pipeline state creation flags, see Diligent::PSO_CREATE_FLAGS.
    PSO_CREATE_FLAGS  Flags      = PSO_CREATE_FLAGS.PSO_CREATE_FLAG_NONE;

    /// An array of ResourceSignaturesCount shader resource signatures that 
    /// define the layout of shader resources in this pipeline state object.
    /// See Diligent::IPipelineResourceSignature.
    ///
    /// \remarks    When this member is null, the pipeline resource layout will be defined
    ///             by PSODesc.ResourceLayout member. In this case the PSO will implicitly
    ///             create a resource signature that can be queried through GetResourceSignature()
    ///             method.
    ///             When ppResourceSignatures is not null, PSODesc.ResourceLayout is ignored and
    ///             should be in it default state.
    IPipelineResourceSignature** ppResourceSignatures = null;

    /// The number of elements in ppResourceSignatures array.
    uint ResourceSignaturesCount = 0;

    // In 32-bit, there might be a problem that may cause mismatch between C++ and C interfaces:
    // PSODesc contains a Uint64 member, so the entire structure has 64-bit alignment. When
    // another struct is derived from PipelineStateCreateInfo, though, the compiler may place
    // another member in this space. To fix this, we add padding.
    uint _Padding;
}

/// Graphics pipeline state initialization information.
struct GraphicsPipelineStateCreateInfo
{
    PipelineStateCreateInfo _PipelineStateCreateInfo;

    /// Graphics pipeline state description.
    GraphicsPipelineDesc GraphicsPipeline; 

    /// Vertex shader to be used with the pipeline.
    IShader* pVS = null;

    /// Pixel shader to be used with the pipeline.
    IShader* pPS = null;

    /// Domain shader to be used with the pipeline.
    IShader* pDS = null;

    /// Hull shader to be used with the pipeline.
    IShader* pHS = null;

    /// Geometry shader to be used with the pipeline.
    IShader* pGS = null;

    /// Amplification shader to be used with the pipeline.
    IShader* pAS = null;

    /// Mesh shader to be used with the pipeline.
    IShader* pMS = null;
}

/// Compute pipeline state description.
struct ComputePipelineStateCreateInfo
{
    PipelineStateCreateInfo _PipelineStateCreateInfo;

    /// Compute shader to be used with the pipeline
    IShader* pCS = null;
}

/// Ray tracing pipeline state initialization information.
struct RayTracingPipelineStateCreateInfo
{
    PipelineStateCreateInfo _PipelineStateCreateInfo;

    /// Ray tracing pipeline description.
    RayTracingPipelineDesc                     RayTracingPipeline;

    /// A pointer to an array of GeneralShaderCount RayTracingGeneralShaderGroup structures that contain shader group description.
    const(RayTracingGeneralShaderGroup)*       pGeneralShaders          = null;

    /// The number of general shader groups.
    uint                                       GeneralShaderCount       = 0;

    /// A pointer to an array of TriangleHitShaderCount RayTracingTriangleHitShaderGroup structures that contain shader group description.
    /// Can be null.
    const(RayTracingTriangleHitShaderGroup)*   pTriangleHitShaders      = null;

    /// The number of triangle hit shader groups.
    uint                                       TriangleHitShaderCount   = 0;

    /// A pointer to an array of ProceduralHitShaderCount RayTracingProceduralHitShaderGroup structures that contain shader group description.
    /// Can be null.
    const(RayTracingProceduralHitShaderGroup)* pProceduralHitShaders    = null;

    /// The number of procedural shader groups.
    uint                                       ProceduralHitShaderCount = 0;

    /// Direct3D12 only: the name of the constant buffer that will be used by the local root signature.
    /// Ignored if RayTracingPipelineDesc::ShaderRecordSize is zero.
    /// In Vulkan backend in HLSL add [[vk::shader_record_ext]] attribute to the constant buffer, in GLSL add shaderRecord layout to buffer.
    const(char)*                               pShaderRecordName        = null;

    /// Direct3D12 only: the maximum hit shader attribute size in bytes.
    /// If zero then maximum allowed size will be used.
    uint                                       MaxAttributeSize         = 0;

    /// Direct3D12 only: the maximum payload size in bytes.
    /// If zero then maximum allowed size will be used.
    uint                                       MaxPayloadSize           = 0;
}

/// Tile pipeline state description
struct TilePipelineDesc
{
    /// The number of render targets in the RTVFormats array.
    ubyte NumRenderTargets       = 0;

    /// The number of samples in render targets.
    ubyte SampleCount            = 1;

    /// Render target formats.
    TEXTURE_FORMAT[DILIGENT_MAX_RENDER_TARGETS] RTVFormats = TEXTURE_FORMAT.TEX_FORMAT_UNKNOWN;
}

/// Tile pipeline state initialization information.
struct TilePipelineStateCreateInfo
{
    PipelineStateCreateInfo _PipelineStateCreateInfo;

    /// Tile pipeline description, see Diligent::TilePipelineDesc.
    TilePipelineDesc TilePipeline;

    /// Tile shader to be used with the pipeline.
    IShader* pTS = null;

}

// {06084AE5-6A71-4FE8-84B9-395DD489A28C}
static const INTERFACE_ID IID_PipelineState =
    INTERFACE_ID(0x6084ae5, 0x6a71, 0x4fe8, [0x84, 0xb9, 0x39, 0x5d, 0xd4, 0x89, 0xa2, 0x8c]);

/// Pipeline state interface
struct IPipelineStateMethods
{
    /// Returns the graphics pipeline description used to create the object.
    /// This method must only be called for a graphics or mesh pipeline.
    const(GraphicsPipelineDesc)** GetGraphicsPipelineDesc(IPipelineState*);

    /// Returns the ray tracing pipeline description used to create the object.
    /// This method must only be called for a ray tracing pipeline.
    const(RayTracingPipelineDesc)** GetRayTracingPipelineDesc(IPipelineState*);

    /// Returns the tile pipeline description used to create the object.
    /// This method must only be called for a tile pipeline.
    const(TilePipelineDesc)** GetTilePipelineDesc(IPipelineState*);

    /// Binds resources for all shaders in the pipeline state.

    /// \param [in] ShaderStages     - Flags that specify shader stages, for which resources will be bound.
    ///                                Any combination of Diligent::SHADER_TYPE may be used.
    /// \param [in] pResourceMapping - Pointer to the resource mapping interface.
    /// \param [in] Flags            - Additional flags. See Diligent::BIND_SHADER_RESOURCES_FLAGS.
    ///
    /// \remarks    This method is only allowed for pipelines that use implicit resource signature
    ///             (e.g. shader resources are defined through ResourceLayout member of the pipeline desc).
    ///             For pipelines that use explicit resource signatures, use
    ///             IPipelineResourceSignature::BindStaticResources() method.
    void* BindStaticResources(IPipelineState*,
                                             SHADER_TYPE                 ShaderStages,
                                             IResourceMapping*           pResourceMapping,
                                             BIND_SHADER_RESOURCES_FLAGS Flags);

    /// Returns the number of static shader resource variables.

    /// \param [in] ShaderType - Type of the shader.
    ///
    /// \remarks    Only static variables (that can be accessed directly through the PSO) are counted.
    ///             Mutable and dynamic variables are accessed through Shader Resource Binding object.
    ///
    ///             This method is only allowed for pipelines that use implicit resource signature
    ///             (e.g. shader resources are defined through ResourceLayout member of the pipeline desc).
    ///             For pipelines that use explicit resource signatures, use
    ///             IPipelineResourceSignature::GetStaticVariableCount() method.
    uint* GetStaticVariableCount(IPipelineState*, SHADER_TYPE ShaderType);

    /// Returns static shader resource variable. If the variable is not found,
    /// returns nullptr.

    /// \param [in] ShaderType - The type of the shader to look up the variable. 
    ///                          Must be one of Diligent::SHADER_TYPE.
    /// \param [in] Name       - Name of the variable.
    ///
    /// \remarks    The method does not increment the reference counter
    ///             of the returned interface.
    ///
    ///             This method is only allowed for pipelines that use implicit resource signature
    ///             (e.g. shader resources are defined through ResourceLayout member of the pipeline desc).
    ///             For pipelines that use explicit resource signatures, use
    ///             IPipelineResourceSignature::GetStaticVariableByName() method.
    IShaderResourceVariable** GetStaticVariableByName(IPipelineState*, SHADER_TYPE ShaderType, const(char)* Name);

    /// Returns static shader resource variable by its index.

    /// \param [in] ShaderType - The type of the shader to look up the variable. 
    ///                          Must be one of Diligent::SHADER_TYPE.
    /// \param [in] Index      - Shader variable index. The index must be between
    ///                          0 and the total number of variables returned by 
    ///                          GetStaticVariableCount().
    ///
    /// \remarks    Only static shader resource variables can be accessed through this method.
    ///             Mutable and dynamic variables are accessed through Shader Resource 
    ///             Binding object.
    ///
    ///             This method is only allowed for pipelines that use implicit resource signature
    ///             (e.g. shader resources are defined through ResourceLayout member of the pipeline desc).
    ///             For pipelines that use explicit resource signatures, use
    ///             IPipelineResourceSignature::GetStaticVariableByIndex() method.
    IShaderResourceVariable** GetStaticVariableByIndex(IPipelineState*, SHADER_TYPE ShaderType, uint Index);

    /// Creates a shader resource binding object.

    /// \param [out] ppShaderResourceBinding - Memory location where pointer to the new shader resource
    ///                                        binding object is written.
    /// \param [in] InitStaticResources      - If set to true, the method will initialize static resources in
    ///                                        the created object, which has the exact same effect as calling 
    ///                                        IPipelineState::InitializeStaticSRBResources().
    ///
    /// \remarks    This method is only allowed for pipelines that use implicit resource signature
    ///             (e.g. shader resources are defined through ResourceLayout member of the pipeline desc).
    ///             For pipelines that use explicit resource signatures, use
    ///             IPipelineResourceSignature::CreateShaderResourceBinding() method.
    void* CreateShaderResourceBinding(IPipelineState*,
                                                     IShaderResourceBinding** ppShaderResourceBinding,
                                                     bool                     InitStaticResources = false);

    /// Initializes static resources in the shader binding object.

    /// If static shader resources were not initialized when the SRB was created,
    /// this method must be called to initialize them before the SRB can be used.
    /// The method should be called after all static variables have been initialized
    /// in the PSO.
    ///
    /// \param [in] pShaderResourceBinding - Shader resource binding object to initialize.
    ///                                      The pipeline state must be compatible
    ///                                      with the shader resource binding object.
    ///
    /// \note   If static resources have already been initialized in the SRB and the method
    ///         is called again, it will have no effect and a warning message will be displayed.
    ///
    /// \remarks    This method is only allowed for pipelines that use implicit resource signature
    ///             (e.g. shader resources are defined through ResourceLayout member of the pipeline desc).
    ///             For pipelines that use explicit resource signatures, use
    ///             IPipelineResourceSignature::InitializeStaticSRBResources() method.
    void* InitializeStaticSRBResources(IPipelineState*, IShaderResourceBinding* pShaderResourceBinding);

    /// Checks if this pipeline state object is compatible with another PSO

    /// If two pipeline state objects are compatible, they can use shader resource binding
    /// objects interchangebly, i.e. SRBs created by one PSO can be committed
    /// when another PSO is bound.
    /// \param [in] pPSO - Pointer to the pipeline state object to check compatibility with.
    /// \return     true if this PSO is compatible with pPSO. false otherwise.
    /// \remarks    The function only checks that shader resource layouts are compatible, but 
    ///             does not check if resource types match. For instance, if a pixel shader in one PSO
    ///             uses a texture at slot 0, and a pixel shader in another PSO uses texture array at slot 0,
    ///             the pipelines will be compatible. However, if you try to use SRB object from the first pipeline
    ///             to commit resources for the second pipeline, a runtime error will occur.\n
    ///             The function only checks compatibility of shader resource layouts. It does not take
    ///             into account vertex shader input layout, number of outputs, etc.
    /// 
    ///             *Technical details*
    ///
    ///             PSOs may be partially compatible when some, but not all pipeline resource signatures are compatible.
    ///             In Vulkan backend, switching PSOs that are partially compatible may increase performance
    ///             as shader resource bindings (that map to descriptor sets) from compatible signatures may be preserved. 
    ///             In Direct3D12 backend, only switching between fully compatible PSOs preserves shader resource bindings, 
    ///             while switching partially compatible PSOs still requires re-binding all resource bindigns from all signatures.
    ///             In other backends the behavior is emualted. Usually, the bindigs from the first N compatible resource signatures
    ///             may be preserved.
    bool* IsCompatibleWith(IPipelineState*, const(IPipelineState)* pPSO);

    /// Returns the number of pipeline resource signatures used by this pipeline.

    /// \remarks  After the PSO is created, pipeline resource signatures are arranged by their binding indices.
    ///           The value returned by this function is given by the maximum signature binding index plus one,
    ///           and thus may not be equal to PipelineStateCreateInfo::ResourceSignaturesCount.
    uint* GetResourceSignatureCount(IPipelineState*);

    /// Returns pipeline resource signature at the give index.

    /// \param [in] Index - Index of the resource signature, same as BindingIndex in PipelineResourceSignatureDesc.
    /// \return     Pointer to pipeline resource signature interface.
    IPipelineResourceSignature** GetResourceSignature(IPipelineState*, uint Index);
}

struct IPipelineStateVtbl { IPipelineStateMethods PipelineState; }
struct IPipelineState { IPipelineStateVtbl* pVtbl; }

const(PipelineStateDesc)* IPipelineState_GetDesc(IPipelineState* object) {
    return cast(const(PipelineStateDesc)*)IDeviceObject_GetDesc(cast(IDeviceObject*)object);
}

const(GraphicsPipelineDesc)** IPipelineState_GetGraphicsPipelineDesc(IPipelineState* pipelineState) {
    return pipelineState.pVtbl.PipelineState.GetGraphicsPipelineDesc(pipelineState);
}

const(RayTracingPipelineDesc)** IPipelineState_GetRayTracingPipelineDesc(IPipelineState* pipelineState) {
    return pipelineState.pVtbl.PipelineState.GetRayTracingPipelineDesc(pipelineState);
}

const(TilePipelineDesc)** IPipelineState_GetTilePipelineDesc(IPipelineState* pipelineState) {
    return pipelineState.pVtbl.PipelineState.GetTilePipelineDesc(pipelineState);
}

void* IPipelineState_BindStaticResources(IPipelineState* pipelineState,
                                             SHADER_TYPE                 shaderStages,
                                             IResourceMapping*           pResourceMapping,
                                             BIND_SHADER_RESOURCES_FLAGS flags) {
    return pipelineState.pVtbl.PipelineState.BindStaticResources(pipelineState, shaderStages, pResourceMapping, flags);
}

uint* IPipelineState_GetStaticVariableCount(IPipelineState* pipelineState, SHADER_TYPE shaderType) {
    return pipelineState.pVtbl.PipelineState.GetStaticVariableCount(pipelineState, shaderType);
}

IShaderResourceVariable** IPipelineState_GetStaticVariableByName(IPipelineState* pipelineState, SHADER_TYPE shaderType, const(char)* name) {
    return pipelineState.pVtbl.PipelineState.GetStaticVariableByName(pipelineState, shaderType, name);
}

IShaderResourceVariable** IPipelineState_GetStaticVariableByIndex(IPipelineState* pipelineState, SHADER_TYPE shaderType, uint index) {
    return pipelineState.pVtbl.PipelineState.GetStaticVariableByIndex(pipelineState, shaderType, index);
}

void* IPipelineState_CreateShaderResourceBinding(IPipelineState* pipelineState,
                                                     IShaderResourceBinding** ppShaderResourceBinding,
                                                     bool                     initStaticResources = false) {
    return pipelineState.pVtbl.PipelineState.CreateShaderResourceBinding(pipelineState, ppShaderResourceBinding, initStaticResources);
}

void* IPipelineState_InitializeStaticSRBResources(IPipelineState* pipelineState, IShaderResourceBinding* pShaderResourceBinding) {
    return pipelineState.pVtbl.PipelineState.InitializeStaticSRBResources(pipelineState, pShaderResourceBinding);
}

bool* IPipelineState_IsCompatibleWith(IPipelineState* pipelineState, const(IPipelineState)* pPSO) {
    return pipelineState.pVtbl.PipelineState.IsCompatibleWith(pipelineState, pPSO);
}

uint* IPipelineState_GetResourceSignatureCount(IPipelineState* pipelineState) {
    return pipelineState.pVtbl.PipelineState.GetResourceSignatureCount(pipelineState);
}

IPipelineResourceSignature** IPipelineState_GetResourceSignature(IPipelineState* pipelineState, uint index) {
    return pipelineState.pVtbl.PipelineState.GetResourceSignature(pipelineState, index);
}
