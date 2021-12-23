/*
 *  Copyright 2021 Thomas Bishop
 *  Distributed under the Boost Software License, Version 1.0
 *  See accompanying file LICENSE or https://www.boost.org/LICENSE_1_0.txt
 *  Modified source based on DiligentCore/Graphics/GraphicsEngine/interface/DeviceContext.h
 *  The original licence follows this statement
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
 
/// Definition of the Diligent::IDeviceContext interface and related data structures
module bindbc.diligent.graphics.devicecontext;

public import bindbc.diligent.primitives.object;
import bindbc.diligent.graphics.graphicstypes;
import bindbc.diligent.graphics.constants;
import bindbc.diligent.graphics.buffer;
import bindbc.diligent.graphics.inputlayout;
import bindbc.diligent.graphics.shader;
public import bindbc.diligent.graphics.texture;
import bindbc.diligent.graphics.sampler;
import bindbc.diligent.graphics.resourcemapping;
import bindbc.diligent.graphics.textureview;
import bindbc.diligent.graphics.bufferview;
import bindbc.diligent.graphics.depthstencilstate;
import bindbc.diligent.graphics.blendstate;
import bindbc.diligent.graphics.pipelinestate;
public import bindbc.diligent.graphics.fence;
import bindbc.diligent.graphics.query;
import bindbc.diligent.graphics.renderpass;
import bindbc.diligent.graphics.framebuffer;
import bindbc.diligent.graphics.commandlist;
import bindbc.diligent.graphics.swapchain;
public import bindbc.diligent.graphics.bottomlevelas;
public import bindbc.diligent.graphics.toplevelas;
import bindbc.diligent.graphics.shaderbindingtable;
import bindbc.diligent.graphics.commandqueue;

public import bindbc.diligent.graphics.shaderresourcebinding;

// {DC92711B-A1BE-4319-B2BD-C662D1CC19E4}
static const INTERFACE_ID IID_DeviceContext =
    INTERFACE_ID(0xdc92711b, 0xa1be, 0x4319, [0xb2, 0xbd, 0xc6, 0x62, 0xd1, 0xcc, 0x19, 0xe4]);

/// Device context description.
struct DeviceContextDesc
{
    /// Device context name. This name is what was specified in
    /// ImmediateContextCreateInfo::Name when the engine was initialized.
    const(char)*  Name = null;

    /// Command queue type that this context uses.

    /// For immediate contexts, this type matches GraphicsAdapterInfo::Queues[QueueId].QueueType.
    /// For deferred contexts, the type is only defined between IDeviceContext::Begin and IDeviceContext::FinishCommandList
    /// calls and matches the type of the immediate context where the command list will be executed.
    COMMAND_QUEUE_TYPE QueueType = COMMAND_QUEUE_TYPE.COMMAND_QUEUE_TYPE_UNKNOWN;

    /// Indicates if this is a deferred context.
    bool IsDeferred = false;

    /// Device contex ID. This value corresponds to the index of the device context
    /// in ppContexts array when the engine was initialized.
    /// When starting recording commands with a deferred context, the context id
    /// of the immediate context where the command list will be executed should be
    /// given to IDeviceContext::Begin() method.
    ubyte ContextId = 0;

    /// Hardware queue index in GraphicsAdapterInfo::Queues array.

    /// \remarks  This member is only defined for immediate contexts and matches
    ///           QueueId member of ImmediateContextCreateInfo struct that was used to
    ///           initialize the context.
    ///
    ///           - Vulkan backend: same as queue family index.
    ///           - Direct3D12 backend:
    ///             - 0 - Graphics queue
    ///             - 1 - Compute queue
    ///             - 2 - Transfer queue
    ///           - Metal backend: index of the unique command queue.
    ubyte QueueId = DEFAULT_QUEUE_ID;


    /// Required texture granularity for copy operations, for a transfer queue.

    /// \remarks  For graphics and compute queues, the granularity is always {1,1,1}.
    ///           For transfer queues, an application must align the texture offsets and sizes
    ///           by the granularity defined by this member.
    ///
    ///           For deferred contexts, this member is only defined between IDeviceContext::Begin and
    ///           IDeviceContext::FinishCommandList calls and matches the texture copy granularity of
    ///           the immediate context where the command list will be executed.
    uint[3] TextureCopyGranularity = [1, 1, 1];
}

/// Draw command flags
enum DRAW_FLAGS : ubyte
{
    /// No flags.
    DRAW_FLAG_NONE                            = 0x00,

    /// Verify the state of index and vertex buffers (if any) used by the draw 
    /// command. State validation is only performed in debug and development builds 
    /// and the flag has no effect in release build.
    DRAW_FLAG_VERIFY_STATES                   = 0x01,

    /// Verify correctness of parameters passed to the draw command.
    DRAW_FLAG_VERIFY_DRAW_ATTRIBS             = 0x02,

    /// Verify that render targets bound to the context are consistent with the pipeline state.
    DRAW_FLAG_VERIFY_RENDER_TARGETS           = 0x04,

    /// Perform all state validation checks
    DRAW_FLAG_VERIFY_ALL                      = DRAW_FLAG_VERIFY_STATES | DRAW_FLAG_VERIFY_DRAW_ATTRIBS | DRAW_FLAG_VERIFY_RENDER_TARGETS,

    /// Indicates that none of the dynamic resource buffers used by the draw command
    /// have been modified by the CPU since the last command.
    ///
    /// \remarks This flag should be used to improve performance when an application issues a
    ///          series of draw commands that use the same pipeline state and shader resources and
    ///          no dynamic buffers (constant or bound as shader resources) are updated between the
    ///          commands.
    ///          Any buffer variable not created with SHADER_VARIABLE_FLAG_NO_DYNAMIC_BUFFERS or 
    ///          PIPELINE_RESOURCE_FLAG_NO_DYNAMIC_BUFFERS flags is counted as dynamic.
    ///          The flag has no effect on dynamic vertex and index buffers.
    ///
    ///          Details
    ///
    ///          D3D12 and Vulkan back-ends have to perform some work to make data in buffers
    ///          available to draw commands. When a dynamic buffer is mapped, the engine allocates
    ///          new memory and assigns a new GPU address to this buffer. When a draw command is issued,
    ///          this GPU address needs to be used. By default the engine assumes that the CPU may
    ///          map the buffer before any command (to write new transformation matrices for example)
    ///          and that all GPU addresses need to always be refreshed. This is not always the case, 
    ///          and the application may use the flag to inform the engine that the data in the buffer 
    ///          stay intact to avoid extra work.\n
    ///          Note that after a new PSO is bound or an SRB is committed, the engine will always set all
    ///          required buffer addresses/offsets regardless of the flag. The flag will only take effect
    ///          on the second and susbequent draw calls that use the same PSO and SRB.\n
    ///          The flag has no effect in D3D11 and OpenGL backends.
    ///
    ///          Implementation details
    ///
    ///          Vulkan backend allocates VK_DESCRIPTOR_TYPE_UNIFORM_BUFFER_DYNAMIC descriptors for all uniform (constant), 
    ///          buffers and VK_DESCRIPTOR_TYPE_STORAGE_BUFFER_DYNAMIC descriptors for storage buffers.
    ///          Note that HLSL structured buffers are mapped to read-only storage buffers in SPIRV and RW buffers
    ///          are mapped to RW-storage buffers.
    ///          By default, all dynamic descriptor sets that have dynamic buffers bound are updated every time a draw command is
    ///          issued (see PipelineStateVkImpl::BindDescriptorSetsWithDynamicOffsets). When DRAW_FLAG_DYNAMIC_RESOURCE_BUFFERS_INTACT
    ///          is specified, dynamic descriptor sets are only bound by the first draw command that uses the PSO and the SRB.
    ///          The flag avoids binding descriptors with the same offsets if none of the dynamic offsets have changed.
    ///
    ///          Direct3D12 backend binds constant buffers to root views. By default the engine assumes that virtual GPU addresses 
    ///          of all dynamic buffers may change between the draw commands and always binds dynamic buffers to root views
    ///          (see RootSignature::CommitRootViews). When DRAW_FLAG_DYNAMIC_RESOURCE_BUFFERS_INTACT is set, root views are only bound
    ///          by the first draw command that uses the PSO + SRB pair. The flag avoids setting the same GPU virtual addresses when
    ///          they stay unchanged.
    DRAW_FLAG_DYNAMIC_RESOURCE_BUFFERS_INTACT = 0x08
}

/// Defines resource state transition mode performed by various commands.

/// Refer to http://diligentgraphics.com/2018/12/09/resource-state-management/ for detailed explanation
/// of resource state management in Diligent Engine.
enum RESOURCE_STATE_TRANSITION_MODE : ubyte
{
    /// Perform no state transitions and no state validation. 
    /// Resource states are not accessed (either read or written) by the command.
    RESOURCE_STATE_TRANSITION_MODE_NONE = 0,

    /// Transition resources to the states required by the specific command.
    /// Resources in unknown state are ignored.
    ///
    /// \note    Any method that uses this mode may alter the state of the resources it works with.
    ///          As automatic state management is not thread-safe, no other thread is allowed to read
    ///          or write the state of the resources being transitioned. 
    ///          If the application intends to use the same resources in other threads simultaneously, it needs to 
    ///          explicitly manage the states using IDeviceContext::TransitionResourceStates() method.
    ///          Refer to http://diligentgraphics.com/2018/12/09/resource-state-management/ for detailed explanation
    ///          of resource state management in Diligent Engine.
    ///
    /// \note    If a resource is used in multiple threads by multiple contexts, there will be race condition accessing
    ///          internal resource state. An application should use manual resource state management in this case.
    RESOURCE_STATE_TRANSITION_MODE_TRANSITION,

    /// Do not transition, but verify that states are correct.
    /// No validation is performed if the state is unknown to the engine.
    /// This mode only has effect in debug and development builds. No validation 
    /// is performed in release build.
    ///
    /// \note    Any method that uses this mode will read the state of resources it works with.
    ///          As automatic state management is not thread-safe, no other thread is allowed to alter
    ///          the state of resources being used by the command. It is safe to read these states.
    RESOURCE_STATE_TRANSITION_MODE_VERIFY
}

/// Defines the draw command attributes.

/// This structure is used by IDeviceContext::Draw().
struct DrawAttribs
{
    /// The number of vertices to draw.
    uint NumVertices = 0;

    /// Additional flags, see Diligent::DRAW_FLAGS.
    DRAW_FLAGS Flags = DRAW_FLAGS.DRAW_FLAG_NONE;

    /// The number of instances to draw. If more than one instance is specified,
    /// instanced draw call will be performed.
    uint NumInstances = 1;

    /// LOCATION (or INDEX, but NOT the byte offset) of the first vertex in the
    /// vertex buffer to start reading vertices from.
    uint StartVertexLocation = 0;

    /// LOCATION (or INDEX, but NOT the byte offset) in the vertex buffer to start
    /// reading instance data from.
    uint FirstInstanceLocation = 0;
}

/// Defines the indexed draw command attributes.

/// This structure is used by IDeviceContext::DrawIndexed().
struct DrawIndexedAttribs
{
    /// The number of indices to draw.
    uint NumIndices = 0;

    /// The type of elements in the index buffer.
    /// Allowed values: VT_UINT16 and VT_uint.
    VALUE_TYPE IndexType = VALUE_TYPE.VT_UNDEFINED;

    /// Additional flags, see Diligent::DRAW_FLAGS.
    DRAW_FLAGS Flags = DRAW_FLAGS.DRAW_FLAG_NONE;

    /// Number of instances to draw. If more than one instance is specified,
    /// instanced draw call will be performed.
    uint NumInstances = 1;

    /// LOCATION (NOT the byte offset) of the first index in
    /// the index buffer to start reading indices from.
    uint FirstIndexLocation = 0;

    /// A constant which is added to each index before accessing the vertex buffer.
    uint BaseVertex = 0;

    /// LOCATION (or INDEX, but NOT the byte offset) in the vertex
    /// buffer to start reading instance data from.
    uint FirstInstanceLocation = 0;
}

/// Defines the indirect draw command attributes.

/// This structure is used by IDeviceContext::DrawIndirect().
struct DrawIndirectAttribs
{
    /// Additional flags, see Diligent::DRAW_FLAGS.
    DRAW_FLAGS Flags = DRAW_FLAGS.DRAW_FLAG_NONE;

    /// State transition mode for indirect draw arguments buffer.
    RESOURCE_STATE_TRANSITION_MODE IndirectAttribsBufferStateTransitionMode = RESOURCE_STATE_TRANSITION_MODE.RESOURCE_STATE_TRANSITION_MODE_NONE;

    /// Offset from the beginning of the buffer to the location of draw command attributes.
    uint IndirectDrawArgsOffset = 0;
}

/// Defines the indexed indirect draw command attributes.

/// This structure is used by IDeviceContext::DrawIndexedIndirect().
struct DrawIndexedIndirectAttribs
{
    /// The type of the elements in the index buffer.
    /// Allowed values: VT_UINT16 and VT_uint.
    VALUE_TYPE IndexType = VALUE_TYPE.VT_UNDEFINED;

    /// Additional flags, see Diligent::DRAW_FLAGS.
    DRAW_FLAGS Flags = DRAW_FLAGS.DRAW_FLAG_NONE;

    /// State transition mode for indirect draw arguments buffer.
    RESOURCE_STATE_TRANSITION_MODE IndirectAttribsBufferStateTransitionMode = RESOURCE_STATE_TRANSITION_MODE.RESOURCE_STATE_TRANSITION_MODE_NONE;

    /// Offset from the beginning of the buffer to the location of draw command attributes.
    uint IndirectDrawArgsOffset = 0;
}

/// Defines the mesh draw command attributes.

/// This structure is used by IDeviceContext::DrawMesh().
struct DrawMeshAttribs
{
    /// The number of dispatched groups
    uint ThreadGroupCount = 1;

    /// Additional flags, see Diligent::DRAW_FLAGS.
    DRAW_FLAGS Flags = DRAW_FLAGS.DRAW_FLAG_NONE;
}

/// Defines the mesh indirect draw command attributes.

/// This structure is used by IDeviceContext::DrawMeshIndirect().
struct DrawMeshIndirectAttribs
{
    /// Additional flags, see Diligent::DRAW_FLAGS.
    DRAW_FLAGS Flags = DRAW_FLAGS.DRAW_FLAG_NONE;
    
    /// State transition mode for indirect draw arguments buffer.
    RESOURCE_STATE_TRANSITION_MODE IndirectAttribsBufferStateTransitionMode = RESOURCE_STATE_TRANSITION_MODE.RESOURCE_STATE_TRANSITION_MODE_NONE;

    /// Offset from the beginning of the buffer to the location of draw command attributes.
    uint IndirectDrawArgsOffset = 0;
}

/// Defines the mesh indirect draw count command attributes.

/// This structure is used by IDeviceContext::DrawMeshIndirectCount().
struct DrawMeshIndirectCountAttribs
{
    /// Additional flags, see Diligent::DRAW_FLAGS.
    DRAW_FLAGS Flags = DRAW_FLAGS.DRAW_FLAG_NONE;

    /// The maximum number of commands that will be read from the count buffer.
    uint MaxCommandCount = 1;

    /// State transition mode for indirect draw arguments buffer.
    RESOURCE_STATE_TRANSITION_MODE IndirectAttribsBufferStateTransitionMode = RESOURCE_STATE_TRANSITION_MODE.RESOURCE_STATE_TRANSITION_MODE_NONE;

    /// Offset from the beginning of the buffer to the location of draw command attributes.
    uint IndirectDrawArgsOffset = 0;

    /// State transition mode for the count buffer.
    RESOURCE_STATE_TRANSITION_MODE CountBufferStateTransitionMode = RESOURCE_STATE_TRANSITION_MODE.RESOURCE_STATE_TRANSITION_MODE_NONE;

    /// Offset from the beginning of the buffer to the location of the command counter.
    uint CountBufferOffset = 0;
}

/// Defines which parts of the depth-stencil buffer to clear.

/// These flags are used by IDeviceContext::ClearDepthStencil().
enum CLEAR_DEPTH_STENCIL_FLAGS : uint
{
    /// Perform no clear.
    CLEAR_DEPTH_FLAG_NONE = 0x00,  

    /// Clear depth part of the buffer.
    CLEAR_DEPTH_FLAG = 0x01,  

    /// Clear stencil part of the buffer.
    CLEAR_STENCIL_FLAG = 0x02   
}

/// Describes dispatch command arguments.

/// This structure is used by IDeviceContext::DispatchCompute().
struct DispatchComputeAttribs
{
    /// The number of groups dispatched in X direction.
    uint ThreadGroupCountX = 1;

    /// The number of groups dispatched in Y direction.
    uint ThreadGroupCountY = 1;

    /// The number of groups dispatched in Z direction.
    uint ThreadGroupCountZ = 1;


    /// Compute group X size. This member is only used
    /// by Metal backend and is ignored by others.
    uint MtlThreadGroupSizeX = 0;

    /// Compute group Y size. This member is only used
    /// by Metal backend and is ignored by others.
    uint MtlThreadGroupSizeY = 0;

    /// Compute group Z size. This member is only used
    /// by Metal backend and is ignored by others.
    uint MtlThreadGroupSizeZ = 0;
}

/// Describes dispatch command arguments.

/// This structure is used by IDeviceContext::DispatchComputeIndirect().
struct DispatchComputeIndirectAttribs
{
    /// State transition mode for indirect dispatch attributes buffer.
    RESOURCE_STATE_TRANSITION_MODE IndirectAttribsBufferStateTransitionMode = RESOURCE_STATE_TRANSITION_MODE.RESOURCE_STATE_TRANSITION_MODE_NONE;

    /// The offset from the beginning of the buffer to the dispatch command arguments.
    uint  DispatchArgsByteOffset = 0;


    /// Compute group X size. This member is only used
    /// by Metal backend and is ignored by others.
    uint MtlThreadGroupSizeX = 0;

    /// Compute group Y size. This member is only used
    /// by Metal backend and is ignored by others.
    uint MtlThreadGroupSizeY = 0;

    /// Compute group Z size. This member is only used
    /// by Metal backend and is ignored by others.
    uint MtlThreadGroupSizeZ = 0;
}

/// Describes tile dispatch command arguments.

/// This structure is used by IDeviceContext::DispatchTile().
struct DispatchTileAttribs
{
    /// The number of threads in one tile dispatched in X direction.
    /// Must not be greater than TileSizeX returned by IDeviceContext::GetTileSize().
    uint ThreadsPerTileX = 1;

    /// The number of threads in one tile dispatched in Y direction.
    /// Must not be greater than TileSizeY returned by IDeviceContext::GetTileSize().
    uint ThreadsPerTileY = 1;

    /// Additional flags, see Diligent::DRAW_FLAGS.
    DRAW_FLAGS Flags = DRAW_FLAGS.DRAW_FLAG_NONE;
}

/// Describes multi-sampled texture resolve command arguments.

/// This structure is used by IDeviceContext::ResolveTextureSubresource().
struct ResolveTextureSubresourceAttribs
{
    /// Mip level of the source multi-sampled texture to resolve.
    uint SrcMipLevel = 0;

    /// Array slice of the source multi-sampled texture to resolve.
    uint SrcSlice = 0;

    /// Source texture state transition mode, see Diligent::RESOURCE_STATE_TRANSITION_MODE.
    RESOURCE_STATE_TRANSITION_MODE SrcTextureTransitionMode = RESOURCE_STATE_TRANSITION_MODE.RESOURCE_STATE_TRANSITION_MODE_NONE;

    /// Mip level of the destination non-multi-sampled texture.
    uint DstMipLevel = 0;

    /// Array slice of the destination non-multi-sampled texture.
    uint DstSlice = 0;

    /// Destination texture state transition mode, see Diligent::RESOURCE_STATE_TRANSITION_MODE.
    RESOURCE_STATE_TRANSITION_MODE DstTextureTransitionMode = RESOURCE_STATE_TRANSITION_MODE.RESOURCE_STATE_TRANSITION_MODE_NONE;

    /// If one or both textures are typeless, specifies the type of the typeless texture.
    /// If both texture formats are not typeless, in which case they must be identical, this member must be
    /// either TEX_FORMAT_UNKNOWN, or match this format.
    TEXTURE_FORMAT Format = TEXTURE_FORMAT.TEX_FORMAT_UNKNOWN;
}

/// Defines allowed flags for IDeviceContext::SetVertexBuffers() function.
enum SET_VERTEX_BUFFERS_FLAGS : ubyte
{
    /// No extra operations.
    SET_VERTEX_BUFFERS_FLAG_NONE  = 0x00,

    /// Reset the vertex buffers to only the buffers specified in this
    /// call. All buffers previously bound to the pipeline will be unbound.
    SET_VERTEX_BUFFERS_FLAG_RESET = 0x01
}

/// Describes the viewport.

/// This structure is used by IDeviceContext::SetViewports().
struct Viewport
{
    /// X coordinate of the left boundary of the viewport.
    float TopLeftX = 0.0f;

    /// Y coordinate of the top boundary of the viewport.
    /// When defining a viewport, DirectX convention is used:
    /// window coordinate systems originates in the LEFT TOP corner
    /// of the screen with Y axis pointing down.
    float TopLeftY = 0.0f;

    /// Viewport width.
    float Width = 0.0f;

    /// Viewport Height.
    float Height = 0.0f;

    /// Minimum depth of the viewport. Ranges between 0 and 1.
    float MinDepth = 0.0f;

    /// Maximum depth of the viewport. Ranges between 0 and 1.
    float MaxDepth = 0.0f;
}

/// Describes the rectangle.

/// This structure is used by IDeviceContext::SetScissorRects().
///
/// \remarks When defining a viewport, Windows convention is used:
///          window coordinate systems originates in the LEFT TOP corner
///          of the screen with Y axis pointing down.
struct Rect
{
    int left = 0;   ///< X coordinate of the left boundary of the viewport.
    int top  = 0;   ///< Y coordinate of the top boundary of the viewport.
    int right = 0;  ///< X coordinate of the right boundary of the viewport.
    int bottom = 0; ///< Y coordinate of the bottom boundary of the viewport.
}

/// Defines copy texture command attributes.

/// This structure is used by IDeviceContext::CopyTexture().
struct CopyTextureAttribs
{
    /// Source texture to copy data from.
    ITexture*                      pSrcTexture = null;

    /// Mip level of the source texture to copy data from.
    uint                         SrcMipLevel = 0;

    /// Array slice of the source texture to copy data from. Must be 0 for non-array textures.
    uint                         SrcSlice = 0;;

    /// Source region to copy. Use nullptr to copy the entire subresource.
    const Box*                     pSrcBox = null;

    /// Source texture state transition mode (see Diligent::RESOURCE_STATE_TRANSITION_MODE).
    RESOURCE_STATE_TRANSITION_MODE SrcTextureTransitionMode = RESOURCE_STATE_TRANSITION_MODE.RESOURCE_STATE_TRANSITION_MODE_NONE;

    /// Destination texture.
    ITexture*                      pDstTexture = null;

    /// Destination mip level.
    uint                         DstMipLevel = 0;

    /// Destination array slice. Must be 0 for non-array textures.
    uint                         DstSlice = 0;

    /// X offset on the destination subresource.
    uint                         DstX = 0;

    /// Y offset on the destination subresource.
    uint                         DstY = 0;

    /// Z offset on the destination subresource
    uint                         DstZ = 0;

    /// Destination texture state transition mode (see Diligent::RESOURCE_STATE_TRANSITION_MODE).
    RESOURCE_STATE_TRANSITION_MODE DstTextureTransitionMode = RESOURCE_STATE_TRANSITION_MODE.RESOURCE_STATE_TRANSITION_MODE_NONE;
}

/// BeginRenderPass command attributes.

/// This structure is used by IDeviceContext::BeginRenderPass().
struct BeginRenderPassAttribs
{
    /// Render pass to begin.
    IRenderPass*    pRenderPass = null;

    /// Framebuffer containing the attachments that are used with the render pass.
    IFramebuffer*   pFramebuffer = null;

    /// The number of elements in pClearValues array.
    uint ClearValueCount = 0;

    /// A pointer to an array of ClearValueCount OptimizedClearValue structures that contains
    /// clear values for each attachment, if the attachment uses a LoadOp value of ATTACHMENT_LOAD_OP_CLEAR
    /// or if the attachment has a depth/stencil format and uses a StencilLoadOp value of ATTACHMENT_LOAD_OP_CLEAR.
    /// The array is indexed by attachment number. Only elements corresponding to cleared attachments are used.
    /// Other elements of pClearValues are ignored.
    OptimizedClearValue* pClearValues = null;

    /// Framebuffer attachments state transition mode before the render pass begins.

    /// This parameter also indicates how attachment states should be handled when
    /// transitioning between subpasses as well as after the render pass ends.
    /// When RESOURCE_STATE_TRANSITION_MODE_TRANSITION is used, attachment states will be
    /// updated so that they match the state in the current subpass as well as the final states
    /// specified by the render pass when the pass ends.
    /// Note that resources are always transitioned. The flag only indicates if the internal
    /// state variables should be updated.
    /// When RESOURCE_STATE_TRANSITION_MODE_NONE or RESOURCE_STATE_TRANSITION_MODE_VERIFY is used,
    /// internal state variables are not updated and it is the application responsibility to set them
    /// manually to match the actual states.
    RESOURCE_STATE_TRANSITION_MODE StateTransitionMode = RESOURCE_STATE_TRANSITION_MODE.RESOURCE_STATE_TRANSITION_MODE_NONE;
}

/// TLAS instance flags that are used in IDeviceContext::BuildTLAS().
enum RAYTRACING_INSTANCE_FLAGS : ubyte
{
    RAYTRACING_INSTANCE_NONE = 0,

    /// Disables face culling for this instance.
    RAYTRACING_INSTANCE_TRIANGLE_FACING_CULL_DISABLE = 0x01,

    /// Indicates that the front face of the triangle for culling purposes is the face that is counter
    /// clockwise in object space relative to the ray origin. Because the facing is determined in object
    /// space, an instance transform matrix does not change the winding, but a geometry transform does.
    RAYTRACING_INSTANCE_TRIANGLE_FRONT_COUNTERCLOCKWISE = 0x02,

    /// Causes this instance to act as though RAYTRACING_GEOMETRY_FLAGS_OPAQUE were specified on all 
    /// geometries referenced by this instance. This behavior can be overridden in the shader with ray flags.
    RAYTRACING_INSTANCE_FORCE_OPAQUE = 0x04,

    /// Causes this instance to act as though RAYTRACING_GEOMETRY_FLAGS_OPAQUE were not specified on all
    /// geometries referenced by this instance. This behavior can be overridden in the shader with ray flags.
    RAYTRACING_INSTANCE_FORCE_NO_OPAQUE = 0x08,

    RAYTRACING_INSTANCE_FLAGS_LAST = RAYTRACING_INSTANCE_FORCE_NO_OPAQUE
}

/// Defines acceleration structure copy mode.

/// These the flags used by IDeviceContext::CopyBLAS() and IDeviceContext::CopyTLAS().
enum COPY_AS_MODE : ubyte
{
    /// Creates a direct copy of the acceleration structure specified in pSrc into the one specified by pDst.
    /// The pDst acceleration structure must have been created with the same parameters as pSrc.
    COPY_AS_MODE_CLONE = 0,

    /// Creates a more compact version of an acceleration structure pSrc into pDst.
    /// The acceleration structure pDst must have been created with a CompactedSize corresponding
    /// to the one returned by IDeviceContext::WriteBLASCompactedSize() or IDeviceContext::WriteTLASCompactedSize()
    /// after the build of the acceleration structure specified by pSrc.
    COPY_AS_MODE_COMPACT,

    COPY_AS_MODE_LAST = COPY_AS_MODE_COMPACT,
}

/// Defines geometry flags for ray tracing.
enum RAYTRACING_GEOMETRY_FLAGS : ubyte
{
    RAYTRACING_GEOMETRY_FLAG_NONE = 0,

    /// Indicates that this geometry does not invoke the any-hit shaders even if present in a hit group.
    RAYTRACING_GEOMETRY_FLAG_OPAQUE = 0x01,

    /// Indicates that the implementation must only call the any-hit shader a single time for each primitive in this geometry.
    /// If this bit is absent an implementation may invoke the any-hit shader more than once for this geometry.
    RAYTRACING_GEOMETRY_FLAG_NO_DUPLICATE_ANY_HIT_INVOCATION = 0x02,

    RAYTRACING_GEOMETRY_FLAGS_LAST = RAYTRACING_GEOMETRY_FLAG_NO_DUPLICATE_ANY_HIT_INVOCATION
}

/// Triangle geometry data description.
struct BLASBuildTriangleData
{
    /// Geometry name used to map a geometry to a hit group in the shader binding table.
    /// Add geometry data to the geometry that is allocated by BLASTriangleDesc with the same name.
    const(char)* GeometryName = null;

    /// Triangle vertices data source.
    /// Triangles are considered "inactive" if the x component of each vertex is NaN.
    /// The buffer must be created with BIND_RAY_TRACING flag.
    IBuffer*    pVertexBuffer = null;

    /// Data offset, in bytes, in pVertexBuffer.
    /// D3D12 and Vulkan: offset must be a multiple of the VertexValueType size.
    /// Metal:            stride must be aligned by RayTracingProperties::VertexBufferAlignmnent
    ///                   and must be a multiple of the VertexStride.
    uint      VertexOffset = 0;

    /// Stride, in bytes, between vertices.
    /// D3D12 and Vulkan: stride must be a multiple of the VertexValueType size.
    /// Metal:            stride must be aligned by RayTracingProperties::VertexBufferAlignmnent.
    uint      VertexStride = 0;

    /// The number of triangle vertices.
    /// Must be less than or equal to BLASTriangleDesc::MaxVertexCount.
    uint      VertexCount = 0;

    /// The type of the vertex components.
    /// This is an optional value. Must be undefined or same as in BLASTriangleDesc. 
    VALUE_TYPE  VertexValueType = VALUE_TYPE.VT_UNDEFINED;

    /// The number of vertex components.
    /// This is an optional value. Must be undefined or same as in BLASTriangleDesc. 
    ubyte       VertexComponentCount = 0;

    /// The number of triangles.
    /// Must equal to VertexCount / 3 if pIndexBuffer is null or must be equal to index count / 3.
    uint      PrimitiveCount = 0;

    /// Triangle indices data source.
    /// Must be null if BLASTriangleDesc::IndexType is undefined.
    /// The buffer must be created with BIND_RAY_TRACING flag.
    IBuffer*    pIndexBuffer = null;

    /// Data offset in bytes in pIndexBuffer.
    /// Offset must be aligned by RayTracingProperties::IndexBufferAlignment
    /// and must be a multiple of the IndexType size.
    uint      IndexOffset = 0;

    /// The type of triangle indices, see Diligent::VALUE_TYPE.
    /// This is an optional value. Must be undefined or same as in BLASTriangleDesc.
    VALUE_TYPE  IndexType = VALUE_TYPE.VT_UNDEFINED;

    /// Geometry transformation data source, must contain a float4x3 matrix aka Diligent::InstanceMatrix.
    /// The buffer must be created with BIND_RAY_TRACING flag.
    /// \note Transform buffer is not supported in Metal backend.
    IBuffer*    pTransformBuffer = null;

    /// Data offset in bytes in pTransformBuffer.
    /// Offset must be aligned by RayTracingProperties::TransformBufferAlignment.
    uint      TransformBufferOffset = 0;

    /// Geometry flags, se Diligent::RAYTRACING_GEOMETRY_FLAGS.
    RAYTRACING_GEOMETRY_FLAGS Flags = RAYTRACING_GEOMETRY_FLAGS.RAYTRACING_GEOMETRY_FLAG_NONE;
}

/// AABB geometry data description.
struct BLASBuildBoundingBoxData
{
    /// Geometry name used to map geometry to hit group in shader binding table.
    /// Put geometry data to geometry that allocated by BLASBoundingBoxDesc with the same name.
    const(char)* GeometryName = null;

    /// AABB data source.
    /// Each AABB defined as { float3 Min; float3 Max } structure.
    /// AABB are considered inactive if AABB.Min.x is NaN.
    /// Buffer must be created with BIND_RAY_TRACING flag.
    IBuffer*    pBoxBuffer = null;

    /// Data offset in bytes in pBoxBuffer.
    /// D3D12 and Vulkan: offset must be aligned by RayTracingProperties::BoxBufferAlignment.
    /// Metal:            offset must be aligned by RayTracingProperties::BoxBufferAlignment
    ///                   and must be a multiple of the BoxStride.
    uint      BoxOffset = 0;

    /// Stride in bytes between each AABB.
    /// Stride must be aligned by RayTracingProperties::BoxBufferAlignment.
    uint      BoxStride = 0;

    /// Number of AABBs.
    /// Must be less than or equal to BLASBoundingBoxDesc::MaxBoxCount.
    uint      BoxCount = 0;

    /// Geometry flags, see Diligent::RAYTRACING_GEOMETRY_FLAGS.
    RAYTRACING_GEOMETRY_FLAGS Flags = RAYTRACING_GEOMETRY_FLAGS.RAYTRACING_GEOMETRY_FLAG_NONE;
}

/// This structure is used by IDeviceContext::BuildBLAS().
struct BuildBLASAttribs
{
    /// Target bottom-level AS.
    /// Access to the BLAS must be externally synchronized.
    IBottomLevelAS*                 pBLAS                       = null;

    /// Bottom-level AS state transition mode (see Diligent::RESOURCE_STATE_TRANSITION_MODE).
    RESOURCE_STATE_TRANSITION_MODE BLASTransitionMode = RESOURCE_STATE_TRANSITION_MODE.RESOURCE_STATE_TRANSITION_MODE_NONE;

    /// Geometry data source buffers state transition mode (see Diligent::RESOURCE_STATE_TRANSITION_MODE).
    RESOURCE_STATE_TRANSITION_MODE GeometryTransitionMode = RESOURCE_STATE_TRANSITION_MODE.RESOURCE_STATE_TRANSITION_MODE_NONE;

    /// A pointer to an array of TriangleDataCount BLASBuildTriangleData structures that contains triangle geometry data.
    /// If Update is true:
    ///     - Only vertex positions (in pVertexBuffer) and transformation (in pTransformBuffer) can be changed.
    ///     - All other content in BLASBuildTriangleData and buffers must be the same as what was used to build BLAS.
    ///     - To disable geometry, make all triangles inactive, see BLASBuildTriangleData::pVertexBuffer description.
    const BLASBuildTriangleData* pTriangleData = null;

    /// The number of triangle grometries.
    /// Must be less than or equal to BottomLevelASDesc::TriangleCount.
    /// If Update is true then the count must be the same as the one used to build BLAS.
    uint                          TriangleDataCount           = 0;

    /// A pointer to an array of BoxDataCount BLASBuildBoundingBoxData structures that contain AABB geometry data.
    /// If Update is true:
    ///     - AABB coordinates (in pBoxBuffer) can be changed.
    ///     - All other content in BLASBuildBoundingBoxData must be same as used to build BLAS.
    ///     - To disable geometry make all AAABBs inactive, see BLASBuildBoundingBoxData::pBoxBuffer description.
    const BLASBuildBoundingBoxData* pBoxData                    = null;

    /// The number of AABB geometries.
    /// Must be less than or equal to BottomLevelASDesc::BoxCount.
    /// If Update is true then the count must be the same as the one used to build BLAS.
    uint                          BoxDataCount                = 0;

    /// The buffer that is used for acceleration structure building.
    /// Must be created with BIND_RAY_TRACING.
    /// Call IBottomLevelAS::GetScratchBufferSizes().Build to get the minimal size for the scratch buffer.
    IBuffer*                        pScratchBuffer              = null;

    /// Offset from the beginning of the buffer.
    /// Offset must be aligned by RayTracingProperties::ScratchBufferAlignment.
    uint                          ScratchBufferOffset         = 0;

    /// Scratch buffer state transition mode (see Diligent::RESOURCE_STATE_TRANSITION_MODE).
    RESOURCE_STATE_TRANSITION_MODE  ScratchBufferTransitionMode = RESOURCE_STATE_TRANSITION_MODE.RESOURCE_STATE_TRANSITION_MODE_NONE;

    /// if false then BLAS will be built from scratch.
    /// If true then previous content of BLAS will be updated.
    /// pBLAS must be created with RAYTRACING_BUILD_AS_ALLOW_UPDATE flag.
    /// An update will be faster than building an acceleration structure from scratch.
    bool                            Update                      = false;
}

/// Can be used to calculate the TLASBuildInstanceData::ContributionToHitGroupIndex depending on instance count,
/// geometry count in each instance (in TLASBuildInstanceData::pBLAS) and shader binding mode in BuildTLASAttribs::BindingMode.
/// 
/// Example:
///  InstanceOffset = BaseContributionToHitGroupIndex;
///  For each instance in TLAS
///     if (Instance.ContributionToHitGroupIndex == TLAS_INSTANCE_OFFSET_AUTO)
///         Instance.ContributionToHitGroupIndex = InstanceOffset;
///         if (BindingMode == HIT_GROUP_BINDING_MODE_PER_GEOMETRY) InstanceOffset += Instance.pBLAS->GeometryCount() * HitGroupStride;
///         if (BindingMode == HIT_GROUP_BINDING_MODE_PER_INSTANCE) InstanceOffset += HitGroupStride;
static const uint TLAS_INSTANCE_OFFSET_AUTO = ~0u;


/// Row-major matrix 
struct InstanceMatrix
{
    ///        rotation        translation
    /// ([0,0]  [0,1]  [0,2])   ([0,3])
    /// ([1,0]  [1,1]  [1,2])   ([1,3])
    /// ([2,0]  [2,1]  [2,2])   ([2,3])
    float[4][3] data;
}

/// This structure is used by BuildTLASAttribs.
struct TLASBuildInstanceData
{
    /// Instance name that is used to map an instance to a hit group in shader binding table.
    const char*               InstanceName    = null;

    /// Bottom-level AS that represents instance geometry.
    /// Once built, TLAS will hold strong reference to pBLAS until next build or copy operation.
    /// Access to the BLAS must be externally synchronized.
    IBottomLevelAS*           pBLAS           = null;

    /// Instance to world transformation.
    InstanceMatrix            Transform;

    /// User-defined value that can be accessed in the shader:
    ///   HLSL: `InstanceID()` in closest-hit and intersection shaders.
    ///   HLSL: `RayQuery::CommittedInstanceID()` within inline ray tracing.
    ///   GLSL: `gl_InstanceCustomIndex` in closest-hit and intersection shaders.
    ///   GLSL: `rayQueryGetIntersectionInstanceCustomIndex` within inline ray tracing.
    ///   MSL:  `intersection_result< instancing >::instance_id`.
    /// Only the lower 24 bits are used.
    uint                    CustomId        = 0;

    /// Instance flags, see Diligent::RAYTRACING_INSTANCE_FLAGS.
    RAYTRACING_INSTANCE_FLAGS Flags = RAYTRACING_INSTANCE_FLAGS.RAYTRACING_INSTANCE_NONE;

    /// Visibility mask for the geometry, the instance may only be hit if rayMask & instance.Mask != 0.
    /// ('rayMask' in GLSL is a 'cullMask' argument of traceRay(), 'rayMask' in HLSL is an 'InstanceInclusionMask' argument of TraceRay()).
    ubyte Mask = 0xFF;

    /// The index used to calculate the hit group location in the shader binding table.
    /// Must be TLAS_INSTANCE_OFFSET_AUTO if BuildTLASAttribs::BindingMode is not SHADER_BINDING_USER_DEFINED.
    /// Only the lower 24 bits are used.
    uint                    ContributionToHitGroupIndex = TLAS_INSTANCE_OFFSET_AUTO;
}

/// Top-level AS instance size in bytes in GPU side.
/// Used to calculate size of BuildTLASAttribs::pInstanceBuffer.
static const uint TLAS_INSTANCE_DATA_SIZE = 64;


/// This structure is used by IDeviceContext::BuildTLAS().
struct BuildTLASAttribs
{
    /// Target top-level AS.
    /// Access to the TLAS must be externally synchronized.
    ITopLevelAS*                    pTLAS                         = null;

    /// Top-level AS state transition mode (see Diligent::RESOURCE_STATE_TRANSITION_MODE).
    RESOURCE_STATE_TRANSITION_MODE  TLASTransitionMode            = RESOURCE_STATE_TRANSITION_MODE.RESOURCE_STATE_TRANSITION_MODE_NONE;

    /// Bottom-level AS (in TLASBuildInstanceData::pBLAS) state transition mode (see Diligent::RESOURCE_STATE_TRANSITION_MODE).
    RESOURCE_STATE_TRANSITION_MODE  BLASTransitionMode            = RESOURCE_STATE_TRANSITION_MODE.RESOURCE_STATE_TRANSITION_MODE_NONE;

    /// A pointer to an array of InstanceCount TLASBuildInstanceData structures that contain instance data.
    /// If Update is true:
    ///     - Any instance data can be changed.
    ///     - To disable an instance set TLASBuildInstanceData::Mask to zero or set empty TLASBuildInstanceData::BLAS to pBLAS.
    const TLASBuildInstanceData*    pInstances                    = null;

    /// The number of instances.
    /// Must be less than or equal to TopLevelASDesc::MaxInstanceCount.
    /// If Update is true then count must be the same as used to build TLAS.
    uint                          InstanceCount                 = 0;

    /// The buffer that will be used to store instance data during AS building.
    /// The buffer size must be at least TLAS_INSTANCE_DATA_SIZE * InstanceCount.
    /// The buffer must be created with BIND_RAY_TRACING flag.
    IBuffer*                        pInstanceBuffer               = null;

    /// Offset from the beginning of the buffer to the location of instance data.
    /// Offset must be aligned by RayTracingProperties::InstanceBufferAlignment.
    uint                          InstanceBufferOffset          = 0;

    /// Instance buffer state transition mode (see Diligent::RESOURCE_STATE_TRANSITION_MODE).
    RESOURCE_STATE_TRANSITION_MODE  InstanceBufferTransitionMode  = RESOURCE_STATE_TRANSITION_MODE.RESOURCE_STATE_TRANSITION_MODE_NONE;

    /// The number of hit shaders that can be bound for a single geometry or an instance (depends on BindingMode).
    ///   - Used to calculate TLASBuildInstanceData::ContributionToHitGroupIndex.
    ///   - Ignored if BindingMode is SHADER_BINDING_USER_DEFINED.
    /// You should use the same value in a shader:
    /// 'MultiplierForGeometryContributionToHitGroupIndex' argument in TraceRay() in HLSL, 'sbtRecordStride' argument in traceRay() in GLSL.
    uint                          HitGroupStride         = 1;

    /// Base offset for the hit group location.
    /// Can be used to bind hit shaders for multiple acceleration structures, see IShaderBindingTable::BindHitGroupForGeometry().
    ///   - Used to calculate TLASBuildInstanceData::ContributionToHitGroupIndex.
    ///   - Ignored if BindingMode is SHADER_BINDING_USER_DEFINED.
    uint                          BaseContributionToHitGroupIndex = 0;

    /// Hit shader binding mode, see Diligent::SHADER_BINDING_MODE.
    /// Used to calculate TLASBuildInstanceData::ContributionToHitGroupIndex.
    HIT_GROUP_BINDING_MODE          BindingMode                   = HIT_GROUP_BINDING_MODE.HIT_GROUP_BINDING_MODE_PER_GEOMETRY;

    /// Buffer that is used for acceleration structure building.
    /// Must be created with BIND_RAY_TRACING.
    /// Call ITopLevelAS::GetScratchBufferSizes().Build to get the minimal size for the scratch buffer.
    /// Access to the TLAS must be externally synchronized.
    IBuffer*                        pScratchBuffer                = null;

    /// Offset from the beginning of the buffer.
    /// Offset must be aligned by RayTracingProperties::ScratchBufferAlignment.
    uint                          ScratchBufferOffset           = 0;

    /// Scratch buffer state transition mode (see Diligent::RESOURCE_STATE_TRANSITION_MODE).
    RESOURCE_STATE_TRANSITION_MODE  ScratchBufferTransitionMode   = RESOURCE_STATE_TRANSITION_MODE.RESOURCE_STATE_TRANSITION_MODE_NONE;

    /// if false then TLAS will be built from scratch.
    /// If true then previous content of TLAS will be updated.
    /// pTLAS must be created with RAYTRACING_BUILD_AS_ALLOW_UPDATE flag.
    /// An update will be faster than building an acceleration structure from scratch.
    bool                            Update                        = false;
}

/// This structure is used by IDeviceContext::CopyBLAS().
struct CopyBLASAttribs
{
    /// Source bottom-level AS.
    /// Access to the BLAS must be externally synchronized.
    IBottomLevelAS*                pSrc              = null;
    
    /// Destination bottom-level AS.
    /// If Mode is COPY_AS_MODE_COMPACT then pDst must be created with CompactedSize
    /// that is greater or equal to the size returned by IDeviceContext::WriteBLASCompactedSize.
    /// Access to the BLAS must be externally synchronized.
    IBottomLevelAS*                pDst              = null;
    
    /// Acceleration structure copy mode, see Diligent::COPY_AS_MODE.
    COPY_AS_MODE                   Mode              = COPY_AS_MODE.COPY_AS_MODE_CLONE;
    
    /// Source bottom-level AS state transition mode (see Diligent::RESOURCE_STATE_TRANSITION_MODE).
    RESOURCE_STATE_TRANSITION_MODE SrcTransitionMode = RESOURCE_STATE_TRANSITION_MODE.RESOURCE_STATE_TRANSITION_MODE_NONE;
    
    /// Destination bottom-level AS state transition mode (see Diligent::RESOURCE_STATE_TRANSITION_MODE).
    RESOURCE_STATE_TRANSITION_MODE DstTransitionMode = RESOURCE_STATE_TRANSITION_MODE.RESOURCE_STATE_TRANSITION_MODE_NONE;
}

/// This structure is used by IDeviceContext::CopyTLAS().
struct CopyTLASAttribs
{
    /// Source top-level AS.
    /// Access to the TLAS must be externally synchronized.
    ITopLevelAS*                   pSrc              = null;

    /// Destination top-level AS.
    /// If Mode is COPY_AS_MODE_COMPACT then pDst must be created with CompactedSize
    /// that is greater or equal to size that returned by IDeviceContext::WriteTLASCompactedSize.
    /// Access to the TLAS must be externally synchronized.
    ITopLevelAS*                   pDst              = null;

    /// Acceleration structure copy mode, see Diligent::COPY_AS_MODE.
    COPY_AS_MODE                   Mode              = COPY_AS_MODE.COPY_AS_MODE_CLONE;

    /// Source top-level AS state transition mode (see Diligent::RESOURCE_STATE_TRANSITION_MODE).
    RESOURCE_STATE_TRANSITION_MODE SrcTransitionMode = RESOURCE_STATE_TRANSITION_MODE.RESOURCE_STATE_TRANSITION_MODE_NONE;

    /// Destination top-level AS state transition mode (see Diligent::RESOURCE_STATE_TRANSITION_MODE).
    RESOURCE_STATE_TRANSITION_MODE DstTransitionMode = RESOURCE_STATE_TRANSITION_MODE.RESOURCE_STATE_TRANSITION_MODE_NONE;
}

/// This structure is used by IDeviceContext::WriteBLASCompactedSize().
struct WriteBLASCompactedSizeAttribs
{
    /// Bottom-level AS.
    IBottomLevelAS*                pBLAS                = null;

    /// The destination buffer into which a 64-bit value representing the acceleration structure compacted size will be written to.
    IBuffer*                       pDestBuffer          = null;

    /// Offset from the beginning of the buffer to the location of the AS compacted size.
    uint                         DestBufferOffset     = 0;

    /// Bottom-level AS state transition mode (see Diligent::RESOURCE_STATE_TRANSITION_MODE).
    RESOURCE_STATE_TRANSITION_MODE BLASTransitionMode   = RESOURCE_STATE_TRANSITION_MODE.RESOURCE_STATE_TRANSITION_MODE_NONE;

    /// Destination buffer state transition mode (see Diligent::RESOURCE_STATE_TRANSITION_MODE).
    RESOURCE_STATE_TRANSITION_MODE BufferTransitionMode = RESOURCE_STATE_TRANSITION_MODE.RESOURCE_STATE_TRANSITION_MODE_NONE;
}

/// This structure is used by IDeviceContext::WriteTLASCompactedSize().
struct WriteTLASCompactedSizeAttribs
{
    /// Top-level AS.
    ITopLevelAS*                   pTLAS                = null;

    /// The destination buffer into which a 64-bit value representing the acceleration structure compacted size will be written to.
    IBuffer*                       pDestBuffer          = null;

    /// Offset from the beginning of the buffer to the location of the AS compacted size.
    uint                         DestBufferOffset     = 0;

    /// Top-level AS state transition mode (see Diligent::RESOURCE_STATE_TRANSITION_MODE).
    RESOURCE_STATE_TRANSITION_MODE TLASTransitionMode   = RESOURCE_STATE_TRANSITION_MODE.RESOURCE_STATE_TRANSITION_MODE_NONE;

    /// Destination buffer state transition mode (see Diligent::RESOURCE_STATE_TRANSITION_MODE).
    RESOURCE_STATE_TRANSITION_MODE BufferTransitionMode = RESOURCE_STATE_TRANSITION_MODE.RESOURCE_STATE_TRANSITION_MODE_NONE;
}

/// This structure is used by IDeviceContext::TraceRays().
struct TraceRaysAttribs
{
    /// Shader binding table.
    const IShaderBindingTable* pSBT  = null;

    uint               DimensionX  = 1; ///< The number of rays dispatched in X direction.
    uint               DimensionY  = 1; ///< The number of rays dispatched in Y direction.
    uint               DimensionZ  = 1; ///< The number of rays dispatched in Z direction.
}

/// This structure is used by IDeviceContext::TraceRaysIndirect().
struct TraceRaysIndirectAttribs
{
    /// Shader binding table.
    const IShaderBindingTable* pSBT  = null;

    /// State transition mode for indirect trace rays attributes buffer.
    RESOURCE_STATE_TRANSITION_MODE IndirectAttribsBufferStateTransitionMode = RESOURCE_STATE_TRANSITION_MODE.RESOURCE_STATE_TRANSITION_MODE_NONE;

    /// The offset from the beginning of the buffer to the trace rays command arguments.
    uint  ArgsByteOffset  = 0;
}

/// This structure is used by IDeviceContext::UpdateSBT().
struct UpdateIndirectRTBufferAttribs
{
    /// Indirect buffer that can be used by IDeviceContext::TraceRaysIndirect() command.
    IBuffer* pAttribsBuffer = null;

    /// Offset in bytes from the beginning of the buffer where SBT data will be recorded.
    uint AttribsBufferOffset = 0;

    /// State transition mode of the attribs buffer (see Diligent::RESOURCE_STATE_TRANSITION_MODE).
    RESOURCE_STATE_TRANSITION_MODE TransitionMode = RESOURCE_STATE_TRANSITION_MODE.RESOURCE_STATE_TRANSITION_MODE_NONE;
}

enum uint REMAINING_MIP_LEVELS   = ~0u;
enum uint REMAINING_ARRAY_SLICES = ~0u;

/// Resource state transition flags.
enum STATE_TRANSITION_FLAGS : ubyte
{
    /// No flags.
    STATE_TRANSITION_FLAG_NONE            = 0,

    /// Indicates that the internal resource state should be updated to the new state
    /// specified by StateTransitionDesc, and the engine should take over the resource state
    /// management. If an application was managing the resource state manually, it is
    /// responsible for making sure that all subresources are indeed in the designated state.
    /// If not used, internal resource state will be unchanged.
    ///
    /// \note This flag cannnot be used when StateTransitionDesc.TransitionType is STATE_TRANSITION_TYPE_BEGIN.
    STATE_TRANSITION_FLAG_UPDATE_STATE    = 1u << 0,

    /// If set, the contents of the resource will be discarded, when possible.
    /// This may avoid potentially expensive operations such as render target decompression
    /// or a pipeline stall when transitioning to COMMON or UAV state.
    STATE_TRANSITION_FLAG_DISCARD_CONTENT = 1u << 1,
}

/// Resource state transition barrier description
struct StateTransitionDesc
{
    /// Resource to transition.
    /// Can be ITexture, IBuffer, IBottomLevelAS, ITopLevelAS.
    IDeviceObject* pResource = null;

    /// When transitioning a texture, first mip level of the subresource range to transition.
    uint FirstMipLevel     = 0;

    /// When transitioning a texture, number of mip levels of the subresource range to transition.
    uint MipLevelsCount    = REMAINING_MIP_LEVELS;

    /// When transitioning a texture, first array slice of the subresource range to transition.
    uint FirstArraySlice   = 0;

    /// When transitioning a texture, number of array slices of the subresource range to transition.
    uint ArraySliceCount    = REMAINING_ARRAY_SLICES;

    /// Resource state before transition.
    /// If this value is RESOURCE_STATE_UNKNOWN, internal resource state will be used, which must be defined in this case.
    ///
    /// \note  Resource state must be compatible with the context type.
    RESOURCE_STATE OldState   = RESOURCE_STATE.RESOURCE_STATE_UNKNOWN;

    /// Resource state after transition.
    /// Must not be RESOURCE_STATE_UNKNOWN or RESOURCE_STATE_UNDEFINED.
    ///
    /// \note  Resource state must be compatible with the context type.
    RESOURCE_STATE NewState   = RESOURCE_STATE.RESOURCE_STATE_UNKNOWN;

    /// State transition type, see Diligent::STATE_TRANSITION_TYPE.

    /// \note When issuing UAV barrier (i.e. OldState and NewState equal RESOURCE_STATE_UNORDERED_ACCESS),
    ///       TransitionType must be STATE_TRANSITION_TYPE_IMMEDIATE.
    STATE_TRANSITION_TYPE TransitionType = STATE_TRANSITION_TYPE.STATE_TRANSITION_TYPE_IMMEDIATE;

    /// State transition flags, see Diligent::STATE_TRANSITION_FLAGS.
    STATE_TRANSITION_FLAGS Flags = STATE_TRANSITION_FLAGS.STATE_TRANSITION_FLAG_NONE;
}

/// Device context interface.

/// \remarks Device context keeps strong references to all objects currently bound to 
///          the pipeline: buffers, states, samplers, shaders, etc.
///          The context also keeps strong reference to the device and
///          the swap chain.
struct IDeviceContextMethods
{
    /// Returns the context description
    const(DeviceContextDesc)** GetDesc(IDeviceContext*);

    /// Begins recording commands in the deferred context.

    /// This method must be called before any command in the deferred context may be recorded.
    ///
    /// \param [in] ImmediateContextId - the ID of the immediate context where commands from this
    ///                                  deferred context will be executed, 
    ///                                  see Diligent::DeviceContextDesc::ContextId.
    /// 
    /// \warning Command list recorded by the context must not be submitted to any other immediate context
    ///          other than one identified by ImmediateContextId.
    void* Begin(IDeviceContext*, uint ImmediateContextId);

    /// Sets the pipeline state.

    /// \param [in] pPipelineState - Pointer to IPipelineState interface to bind to the context.
    ///
    /// \remarks Supported contexts for graphics and mesh pipeline:        graphics.
    ///          Supported contexts for compute and ray tracing pipeline:  graphics and compute.
    void* SetPipelineState(IDeviceContext*, IPipelineState* pPipelineState);

    /// Transitions shader resources to the states required by Draw or Dispatch command.
    ///
    /// \param [in] pPipelineState         - Pipeline state object that was used to create the shader resource binding.
    /// \param [in] pShaderResourceBinding - Shader resource binding whose resources will be transitioned.
    ///
    /// \remarks This method explicitly transitiones all resources except ones in unknown state to the states required 
    ///          by Draw or Dispatch command.
    ///          If this method was called, there is no need to use Diligent::RESOURCE_STATE_TRANSITION_MODE_TRANSITION
    ///          when calling IDeviceContext::CommitShaderResources()
    ///
    /// \remarks Resource state transitioning is not thread safe. As the method may alter the states 
    ///          of resources referenced by the shader resource binding, no other thread is allowed to read or 
    ///          write these states.
    ///
    ///          If the application intends to use the same resources in other threads simultaneously, it needs to 
    ///          explicitly manage the states using IDeviceContext::TransitionResourceStates() method.
    ///          Refer to http://diligentgraphics.com/2018/12/09/resource-state-management/ for detailed explanation
    ///          of resource state management in Diligent Engine.
    void* TransitionShaderResources(IDeviceContext*, 
                                                   IPipelineState*         pPipelineState, 
                                                   IShaderResourceBinding* pShaderResourceBinding);

    /// Commits shader resources to the device context.

    /// \param [in] pShaderResourceBinding - Shader resource binding whose resources will be committed.
    ///                                      If pipeline state contains no shader resources, this parameter
    ///                                      can be null.
    /// \param [in] StateTransitionMode    - State transition mode (see Diligent::RESOURCE_STATE_TRANSITION_MODE).
    ///
    /// \remarks If Diligent::RESOURCE_STATE_TRANSITION_MODE_TRANSITION mode is used,
    ///          the engine will also transition all shader resources to required states. If the flag
    ///          is not set, it is assumed that all resources are already in correct states.\n
    ///          Resources can be explicitly transitioned to required states by calling 
    ///          IDeviceContext::TransitionShaderResources() or IDeviceContext::TransitionResourceStates().\n
    ///
    /// \remarks Automatic resource state transitioning is not thread-safe.
    ///
    ///          - If Diligent::RESOURCE_STATE_TRANSITION_MODE_TRANSITION mode is used, the method may alter the states 
    ///            of resources referenced by the shader resource binding and no other thread is allowed to read or write these states.
    ///
    ///          - If Diligent::RESOURCE_STATE_TRANSITION_MODE_VERIFY mode is used, the method will read the states, so no other thread
    ///            should alter the states by calling any of the methods that use Diligent::RESOURCE_STATE_TRANSITION_MODE_TRANSITION mode.
    ///            It is safe for other threads to read the states.
    ///
    ///          - If Diligent::RESOURCE_STATE_TRANSITION_MODE_NONE mode is used, the method does not access the states of resources.
    ///
    ///          If the application intends to use the same resources in other threads simultaneously, it should manage the states
    ///          manually by setting the state to Diligent::RESOURCE_STATE_UNKNOWN (which will disable automatic state 
    ///          management) using IBuffer::SetState() or ITexture::SetState() and explicitly transitioning the states with 
    ///          IDeviceContext::TransitionResourceStates().
    ///          Refer to http://diligentgraphics.com/2018/12/09/resource-state-management/ for detailed explanation
    ///          of resource state management in Diligent Engine.
    ///
    ///          If an application calls any method that changes the state of any resource after it has been committed, the
    ///          application is responsible for transitioning the resource back to correct state using one of the available methods
    ///          before issuing the next draw or dispatch command.
    void* CommitShaderResources(IDeviceContext*,
                                               IShaderResourceBinding*        pShaderResourceBinding,
                                               RESOURCE_STATE_TRANSITION_MODE StateTransitionMode);

    /// Sets the stencil reference value.

    /// \param [in] StencilRef - Stencil reference value.
    ///
    /// \remarks Supported contexts: graphics.
    void* SetStencilRef(IDeviceContext*, uint StencilRef);


    /// \param [in] pBlendFactors - Array of four blend factors, one for each RGBA component. 
    ///                             These factors are used if the blend state uses one of the 
    ///                             Diligent::BLEND_FACTOR_BLEND_FACTOR or 
    ///                             Diligent::BLEND_FACTOR_INV_BLEND_FACTOR 
    ///                             blend factors. If nullptr is provided,
    ///                             default blend factors array {1,1,1,1} will be used.
    ///
    /// \remarks Supported contexts: graphics.
    void* SetBlendFactors(IDeviceContext*, const(float)* pBlendFactors = null);


    /// Binds vertex buffers to the pipeline.

    /// \param [in] StartSlot           - The first input slot for binding. The first vertex buffer is 
    ///                                   explicitly bound to the start slot; each additional vertex buffer 
    ///                                   in the array is implicitly bound to each subsequent input slot. 
    /// \param [in] NumBuffersSet       - The number of vertex buffers in the array.
    /// \param [in] ppBuffers           - A pointer to an array of vertex buffers. 
    ///                                   The buffers must have been created with the Diligent::BIND_VERTEX_BUFFER flag.
    /// \param [in] pOffsets            - Pointer to an array of offset values; one offset value for each buffer 
    ///                                   in the vertex-buffer array. Each offset is the number of bytes between 
    ///                                   the first element of a vertex buffer and the first element that will be 
    ///                                   used. If this parameter is nullptr, zero offsets for all buffers will be used.
    /// \param [in] StateTransitionMode - State transition mode for buffers being set (see Diligent::RESOURCE_STATE_TRANSITION_MODE).
    /// \param [in] Flags               - Additional flags. See Diligent::SET_VERTEX_BUFFERS_FLAGS for a list of allowed values.
    ///
    /// \remarks The device context keeps strong references to all bound vertex buffers.
    ///          Thus a buffer cannot be released until it is unbound from the context.\n
    ///          It is suggested to specify Diligent::SET_VERTEX_BUFFERS_FLAG_RESET flag
    ///          whenever possible. This will assure that no buffers from previous draw calls
    ///          are bound to the pipeline.
    ///
    /// \remarks When StateTransitionMode is Diligent::RESOURCE_STATE_TRANSITION_MODE_TRANSITION, the method will 
    ///          transition all buffers in known states to Diligent::RESOURCE_STATE_VERTEX_BUFFER. Resource state 
    ///          transitioning is not thread safe, so no other thread is allowed to read or write the states of 
    ///          these buffers.
    ///
    ///          If the application intends to use the same resources in other threads simultaneously, it needs to 
    ///          explicitly manage the states using IDeviceContext::TransitionResourceStates() method.
    ///          Refer to http://diligentgraphics.com/2018/12/09/resource-state-management/ for detailed explanation
    ///          of resource state management in Diligent Engine.
    ///
    /// \remarks Supported contexts: graphics.
    void* SetVertexBuffers(IDeviceContext*,
                                          uint                         StartSlot, 
                                          uint                         NumBuffersSet, 
                                          IBuffer**                      ppBuffers, 
                                          const uint*                  pOffsets,
                                          RESOURCE_STATE_TRANSITION_MODE StateTransitionMode,
                                          SET_VERTEX_BUFFERS_FLAGS       Flags);


    /// Invalidates the cached context state.

    /// This method should be called by an application to invalidate 
    /// internal cached states.
    void* InvalidateState(IDeviceContext*);


    /// Binds an index buffer to the pipeline.

    /// \param [in] pIndexBuffer        - Pointer to the index buffer. The buffer must have been created 
    ///                                   with the Diligent::BIND_INDEX_BUFFER flag.
    /// \param [in] ByteOffset          - Offset from the beginning of the buffer to 
    ///                                   the start of index data.
    /// \param [in] StateTransitionMode - State transition mode for the index buffer to bind (see Diligent::RESOURCE_STATE_TRANSITION_MODE).
    ///
    /// \remarks The device context keeps strong reference to the index buffer.
    ///          Thus an index buffer object cannot be released until it is unbound 
    ///          from the context.
    ///
    /// \remarks When StateTransitionMode is Diligent::RESOURCE_STATE_TRANSITION_MODE_TRANSITION, the method will 
    ///          transition the buffer to Diligent::RESOURCE_STATE_INDEX_BUFFER (if its state is not unknown). Resource 
    ///          state transitioning is not thread safe, so no other thread is allowed to read or write the state of 
    ///          the buffer.
    ///
    ///          If the application intends to use the same resource in other threads simultaneously, it needs to 
    ///          explicitly manage the states using IDeviceContext::TransitionResourceStates() method.
    ///          Refer to http://diligentgraphics.com/2018/12/09/resource-state-management/ for detailed explanation
    ///          of resource state management in Diligent Engine.
    ///
    /// \remarks Supported contexts: graphics.
    void* SetIndexBuffer(IDeviceContext*,
                                        IBuffer*                       pIndexBuffer,
                                        uint                           ByteOffset,
                                        RESOURCE_STATE_TRANSITION_MODE StateTransitionMode);


    /// Sets an array of viewports.

    /// \param [in] NumViewports - Number of viewports to set.
    /// \param [in] pViewports   - An array of Viewport structures describing the viewports to bind.
    /// \param [in] RTWidth      - Render target width. If 0 is provided, width of the currently bound render target will be used.
    /// \param [in] RTHeight     - Render target height. If 0 is provided, height of the currently bound render target will be used.
    ///
    /// \remarks
    /// DirectX and OpenGL use different window coordinate systems. In DirectX, the coordinate system origin
    /// is in the left top corner of the screen with Y axis pointing down. In OpenGL, the origin
    /// is in the left bottom corner of the screen with Y axis pointing up. Render target size is 
    /// required to convert viewport from DirectX to OpenGL coordinate system if OpenGL device is used.\n\n
    /// All viewports must be set atomically as one operation. Any viewports not 
    /// defined by the call are disabled.\n\n
    /// You can set the viewport size to match the currently bound render target using the
    /// following call:
    ///
    ///     pContext->SetViewports(1, nullptr, 0, 0);
    ///
    /// \remarks Supported contexts: graphics.
    void* SetViewports(IDeviceContext*,
                                      uint          NumViewports,
                                      const Viewport* pViewports, 
                                      uint          RTWidth, 
                                      uint          RTHeight);


    /// Sets active scissor rects.

    /// \param [in] NumRects - Number of scissor rectangles to set.
    /// \param [in] pRects   - An array of Rect structures describing the scissor rectangles to bind.
    /// \param [in] RTWidth  - Render target width. If 0 is provided, width of the currently bound render target will be used.
    /// \param [in] RTHeight - Render target height. If 0 is provided, height of the currently bound render target will be used.
    ///
    /// \remarks
    /// DirectX and OpenGL use different window coordinate systems. In DirectX, the coordinate system origin
    /// is in the left top corner of the screen with Y axis pointing down. In OpenGL, the origin
    /// is in the left bottom corner of the screen with Y axis pointing up. Render target size is 
    /// required to convert viewport from DirectX to OpenGL coordinate system if OpenGL device is used.\n\n
    /// All scissor rects must be set atomically as one operation. Any rects not 
    /// defined by the call are disabled.
    ///
    /// \remarks Supported contexts: graphics.
    void* SetScissorRects(IDeviceContext*,
                                         uint      NumRects,
                                         const Rect* pRects,
                                         uint      RTWidth,
                                         uint      RTHeight);


    /// Binds one or more render targets and the depth-stencil buffer to the context. It also
    /// sets the viewport to match the first non-null render target or depth-stencil buffer.

    /// \param [in] NumRenderTargets    - Number of render targets to bind.
    /// \param [in] ppRenderTargets     - Array of pointers to ITextureView that represent the render 
    ///                                   targets to bind to the device. The type of each view in the 
    ///                                   array must be Diligent::TEXTURE_VIEW_RENDER_TARGET.
    /// \param [in] pDepthStencil       - Pointer to the ITextureView that represents the depth stencil to 
    ///                                   bind to the device. The view type must be
    ///                                   Diligent::TEXTURE_VIEW_DEPTH_STENCIL.
    /// \param [in] StateTransitionMode - State transition mode of the render targets and depth stencil buffer being set (see Diligent::RESOURCE_STATE_TRANSITION_MODE).
    ///
    /// \remarks     The device context will keep strong references to all bound render target 
    ///              and depth-stencil views. Thus these views (and consequently referenced textures) 
    ///              cannot be released until they are unbound from the context.\n
    ///              Any render targets not defined by this call are set to nullptr.\n\n
    ///
    /// \remarks When StateTransitionMode is Diligent::RESOURCE_STATE_TRANSITION_MODE_TRANSITION, the method will 
    ///          transition all render targets in known states to Diligent::RESOURCE_STATE_REDER_TARGET,
    ///          and the depth-stencil buffer to Diligent::RESOURCE_STATE_DEPTH_WRITE state.
    ///          Resource state transitioning is not thread safe, so no other thread is allowed to read or write 
    ///          the states of resources used by the command.
    ///
    ///          If the application intends to use the same resource in other threads simultaneously, it needs to 
    ///          explicitly manage the states using IDeviceContext::TransitionResourceStates() method.
    ///          Refer to http://diligentgraphics.com/2018/12/09/resource-state-management/ for detailed explanation
    ///          of resource state management in Diligent Engine.
    ///
    /// \remarks Supported contexts: graphics.
    void* SetRenderTargets(IDeviceContext*,
                                          uint                         NumRenderTargets,
                                          ITextureView*[]              ppRenderTargets,
                                          ITextureView*                  pDepthStencil,
                                          RESOURCE_STATE_TRANSITION_MODE StateTransitionMode);


    /// Begins a new render pass.

    /// \param [in] Attribs - The command attributes, see Diligent::BeginRenderPassAttribs for details.
    ///
    /// \remarks Supported contexts: graphics.
    void* BeginRenderPass(IDeviceContext*, const BeginRenderPassAttribs* Attribs);


    /// Transitions to the next subpass in the render pass instance.
    ///
    /// \remarks Supported contexts: graphics.
    void* NextSubpass(IDeviceContext*);


    /// Ends current render pass.
    ///
    /// \remarks Supported contexts: graphics.
    void* EndRenderPass(IDeviceContext*);


    /// Executes a draw command.

    /// \param [in] Attribs - Draw command attributes, see Diligent::DrawAttribs for details.
    ///
    /// \remarks  If Diligent::DRAW_FLAG_VERIFY_STATES flag is set, the method reads the state of vertex
    ///           buffers, so no other threads are allowed to alter the states of the same resources.
    ///           It is OK to read these states.
    ///
    ///           If the application intends to use the same resources in other threads simultaneously, it needs to 
    ///           explicitly manage the states using IDeviceContext::TransitionResourceStates() method.
    ///
    /// \remarks Supported contexts: graphics.
    void* Draw(IDeviceContext*, const DrawAttribs* Attribs);


    /// Executes an indexed draw command.

    /// \param [in] Attribs - Draw command attributes, see Diligent::DrawIndexedAttribs for details.
    ///
    /// \remarks  If Diligent::DRAW_FLAG_VERIFY_STATES flag is set, the method reads the state of vertex/index
    ///           buffers, so no other threads are allowed to alter the states of the same resources.
    ///           It is OK to read these states.
    ///
    ///           If the application intends to use the same resources in other threads simultaneously, it needs to 
    ///           explicitly manage the states using IDeviceContext::TransitionResourceStates() method.
    ///
    /// \remarks Supported contexts: graphics.
    void* DrawIndexed(IDeviceContext*, const DrawIndexedAttribs* Attribs);


    /// Executes an indirect draw command.

    /// \param [in] Attribs        - Structure describing the command attributes, see Diligent::DrawIndirectAttribs for details.
    /// \param [in] pAttribsBuffer - Pointer to the buffer, from which indirect draw attributes will be read.
    ///                              The buffer must contain the following arguments at the specified offset:
    ///                                  uint NumVertices;
    ///                                  uint NumInstances;
    ///                                  uint StartVertexLocation;
    ///                                  uint FirstInstanceLocation;
    ///
    /// \remarks  If IndirectAttribsBufferStateTransitionMode member is Diligent::RESOURCE_STATE_TRANSITION_MODE_TRANSITION,
    ///           the method may transition the state of the indirect draw arguments buffer. This is not a thread safe operation, 
    ///           so no other thread is allowed to read or write the state of the buffer.
    ///
    ///           If Diligent::DRAW_FLAG_VERIFY_STATES flag is set, the method reads the state of vertex/index
    ///           buffers, so no other threads are allowed to alter the states of the same resources.
    ///           It is OK to read these states.
    ///
    ///           If the application intends to use the same resources in other threads simultaneously, it needs to 
    ///           explicitly manage the states using IDeviceContext::TransitionResourceStates() method.
    ///
    /// \remarks Supported contexts: graphics.
    void* DrawIndirect(IDeviceContext*,
                                      const DrawIndirectAttribs* Attribs,
                                      IBuffer*                      pAttribsBuffer);


    /// Executes an indexed indirect draw command.

    /// \param [in] Attribs        - Structure describing the command attributes, see Diligent::DrawIndexedIndirectAttribs for details.
    /// \param [in] pAttribsBuffer - Pointer to the buffer, from which indirect draw attributes will be read.
    ///                              The buffer must contain the following arguments at the specified offset:
    ///                                  uint NumIndices;
    ///                                  uint NumInstances;
    ///                                  uint FirstIndexLocation;
    ///                                  uint BaseVertex;
    ///                                  uint FirstInstanceLocation
    ///
    /// \remarks  If IndirectAttribsBufferStateTransitionMode member is Diligent::RESOURCE_STATE_TRANSITION_MODE_TRANSITION,
    ///           the method may transition the state of the indirect draw arguments buffer. This is not a thread safe operation, 
    ///           so no other thread is allowed to read or write the state of the buffer.
    ///
    ///           If Diligent::DRAW_FLAG_VERIFY_STATES flag is set, the method reads the state of vertex/index
    ///           buffers, so no other threads are allowed to alter the states of the same resources.
    ///           It is OK to read these states.
    ///
    ///           If the application intends to use the same resources in other threads simultaneously, it needs to 
    ///           explicitly manage the states using IDeviceContext::TransitionResourceStates() method.
    ///
    /// \remarks Supported contexts: graphics.
    void* DrawIndexedIndirect(IDeviceContext*,
                                             const DrawIndexedIndirectAttribs* Attribs,
                                             IBuffer*                             pAttribsBuffer);


    /// Executes a mesh draw command.

    /// \param [in] Attribs - Draw command attributes, see Diligent::DrawMeshAttribs for details.
    /// 
    /// \remarks  For compatibility between Direct3D12 and Vulkan, only a single work group dimension is used.
    ///           Also in the shader, 'numthreads' and 'local_size' attributes must define only the first dimension,
    ///           for example: '[numthreads(ThreadCount, 1, 1)]' or 'layout(local_size_x = ThreadCount) in'.
    ///
    /// \remarks Supported contexts: graphics.
    void* DrawMesh(IDeviceContext*, const DrawMeshAttribs* Attribs);


    /// Executes an mesh indirect draw command.

    /// \param [in] Attribs        - Structure describing the command attributes, see Diligent::DrawMeshIndirectAttribs for details.
    /// \param [in] pAttribsBuffer - Pointer to the buffer, from which indirect draw attributes will be read.
    ///                              The buffer must contain the following arguments at the specified offset:
    ///                                Direct3D12:
    ///                                     uint ThreadGroupCountX;
    ///                                     uint ThreadGroupCountY;
    ///                                     uint ThreadGroupCountZ;
    ///                                Vulkan:
    ///                                     uint TaskCount;
    ///                                     uint FirstTask;
    ///
    /// \remarks  For compatibility between Direct3D12 and Vulkan and with direct call (DrawMesh) use the first element in the structure,
    ///           for example: Direct3D12 {TaskCount, 1, 1}, Vulkan {TaskCount, 0}.
    ///
    /// \remarks  If IndirectAttribsBufferStateTransitionMode member is Diligent::RESOURCE_STATE_TRANSITION_MODE_TRANSITION,
    ///           the method may transition the state of the indirect draw arguments buffer. This is not a thread safe operation, 
    ///           so no other thread is allowed to read or write the state of the buffer.
    ///
    ///           If the application intends to use the same resources in other threads simultaneously, it needs to 
    ///           explicitly manage the states using IDeviceContext::TransitionResourceStates() method.
    ///
    /// \remarks Supported contexts: graphics.
    void* DrawMeshIndirect(IDeviceContext*,
                                          const DrawMeshIndirectAttribs* Attribs,
                                          IBuffer*                          pAttribsBuffer);


    /// Executes an mesh indirect draw command with indirect command count buffer.

    /// \param [in] Attribs        - Structure describing the command attributes, see Diligent::DrawMeshIndirectCountAttribs for details.
    /// \param [in] pAttribsBuffer - Pointer to the buffer, from which indirect draw attributes will be read.
    ///                              The buffer must contain the following arguments at the specified offset:
    ///                                Direct3D12:
    ///                                     uint ThreadGroupCountX;
    ///                                     uint ThreadGroupCountY;
    ///                                     uint ThreadGroupCountZ;
    ///                                Vulkan:
    ///                                     uint TaskCount;
    ///                                     uint FirstTask;
    ///                              Size of the buffer must be sizeof(uint[3]) * Attribs.MaxDrawCommands.
    /// \param [in] pCountBuffer   - Pointer to the buffer, from which uint value with draw count will be read.
    ///
    /// \remarks  For compatibility between Direct3D12 and Vulkan and with direct call (DrawMesh) use the first element in the structure,
    ///           for example: Direct3D12 {TaskCount, 1, 1}, Vulkan {TaskCount, 0}.
    ///
    /// \remarks  If IndirectAttribsBufferStateTransitionMode member is Diligent::RESOURCE_STATE_TRANSITION_MODE_TRANSITION,
    ///           the method may transition the state of the indirect draw arguments buffer. This is not a thread safe operation, 
    ///           so no other thread is allowed to read or write the state of the buffer.
    ///
    ///           If the application intends to use the same resources in other threads simultaneously, it needs to 
    ///           explicitly manage the states using IDeviceContext::TransitionResourceStates() method.
    ///
    /// \remarks Supported contexts: graphics.
    void* DrawMeshIndirectCount(IDeviceContext*,
                                               const DrawMeshIndirectCountAttribs* Attribs,
                                               IBuffer*                               pAttribsBuffer,
                                               IBuffer*                               pCountBuffer);


    /// Executes a dispatch compute command.

    /// \param [in] Attribs - Dispatch command attributes, see Diligent::DispatchComputeAttribs for details.
    ///
    /// \remarks    In Metal, the compute group sizes are defined by the dispatch command rather than by
    ///             the compute shader. When the shader is compiled from HLSL or GLSL, the engine will
    ///             use the group size information from the shader. When using MSL, an application should
    ///             provide the compute group dimensions through MtlThreadGroupSizeX, MtlThreadGroupSizeY, 
    ///             and MtlThreadGroupSizeZ members.
    ///
    /// \remarks Supported contexts: graphics, compute.
    void* DispatchCompute(IDeviceContext*, const DispatchComputeAttribs* Attribs);


    /// Executes an indirect dispatch compute command.

    /// \param [in] Attribs        - The command attributes, see Diligent::DispatchComputeIndirectAttribs for details.
    /// \param [in] pAttribsBuffer - Pointer to the buffer containing indirect dispatch attributes.
    ///                              The buffer must contain the following arguments at the specified offset:
    ///                                 uint ThreadGroupCountX;
    ///                                 uint ThreadGroupCountY;
    ///                                 uint ThreadGroupCountZ;
    ///
    /// \remarks  If IndirectAttribsBufferStateTransitionMode member is Diligent::RESOURCE_STATE_TRANSITION_MODE_TRANSITION,
    ///           the method may transition the state of indirect dispatch arguments buffer. This is not a thread safe operation, 
    ///           so no other thread is allowed to read or write the state of the same resource.
    ///
    ///           If the application intends to use the same resources in other threads simultaneously, it needs to 
    ///           explicitly manage the states using IDeviceContext::TransitionResourceStates() method.
    ///
    ///           In Metal, the compute group sizes are defined by the dispatch command rather than by
    ///           the compute shader. When the shader is compiled from HLSL or GLSL, the engine will
    ///           use the group size information from the shader. When using MSL, an application should
    ///           provide the compute group dimensions through MtlThreadGroupSizeX, MtlThreadGroupSizeY, 
    ///           and MtlThreadGroupSizeZ members.
    ///
    /// \remarks Supported contexts: graphics, compute.
    void* DispatchComputeIndirect(IDeviceContext*,
                                                 const DispatchComputeIndirectAttribs* Attribs,
                                                 IBuffer*                                 pAttribsBuffer);


    /// Executes a dispatch tile command.

    /// \param [in] Attribs - The command attributes, see Diligent::DispatchTileAttribs for details.
    void* DispatchTile(IDeviceContext*, const DispatchTileAttribs* Attribs);


    /// Returns current render pass tile size.

    /// \param [out] TileSizeX - Tile size in X direction.
    /// \param [out] TileSizeY - Tile size in X direction.
    ///
    /// \remarks Result will be zero if there are no active render pass or render targets.
    void* GetTileSize(IDeviceContext*, uint* TileSizeX, uint* TileSizeY);


    /// Clears a depth-stencil view.

    /// \param [in] pView               - Pointer to ITextureView interface to clear. The view type must be 
    ///                                   Diligent::TEXTURE_VIEW_DEPTH_STENCIL.
    /// \param [in] StateTransitionMode - state transition mode of the depth-stencil buffer to clear.
    /// \param [in] ClearFlags          - Indicates which parts of the buffer to clear, see Diligent::CLEAR_DEPTH_STENCIL_FLAGS.
    /// \param [in] fDepth              - Value to clear depth part of the view with.
    /// \param [in] Stencil             - Value to clear stencil part of the view with.
    ///
    /// \remarks The full extent of the view is always cleared. Viewport and scissor settings are not applied.
    /// \note The depth-stencil view must be bound to the pipeline for clear operation to be performed.
    ///
    /// \remarks When StateTransitionMode is Diligent::RESOURCE_STATE_TRANSITION_MODE_TRANSITION, the method will 
    ///          transition the state of the texture to the state required by clear operation. 
    ///          In Direct3D12, this satate is always Diligent::RESOURCE_STATE_DEPTH_WRITE, however in Vulkan
    ///          the state depends on whether the depth buffer is bound to the pipeline.
    ///
    ///          Resource state transitioning is not thread safe, so no other thread is allowed to read or write 
    ///          the state of resources used by the command.
    ///          Refer to http://diligentgraphics.com/2018/12/09/resource-state-management/ for detailed explanation
    ///          of resource state management in Diligent Engine.
    ///
    /// \remarks Supported contexts: graphics.
    void* ClearDepthStencil(IDeviceContext*,
                                           ITextureView*                  pView,
                                           CLEAR_DEPTH_STENCIL_FLAGS      ClearFlags,
                                           float                          fDepth,
                                           ubyte                          Stencil,
                                           RESOURCE_STATE_TRANSITION_MODE StateTransitionMode);


    /// Clears a render target view

    /// \param [in] pView               - Pointer to ITextureView interface to clear. The view type must be 
    ///                                   Diligent::TEXTURE_VIEW_RENDER_TARGET.
    /// \param [in] RGBA                - A 4-component array that represents the color to fill the render target with.
    ///                                   If nullptr is provided, the default array {0,0,0,0} will be used.
    /// \param [in] StateTransitionMode - Defines required state transitions (see Diligent::RESOURCE_STATE_TRANSITION_MODE)
    ///
    /// \remarks The full extent of the view is always cleared. Viewport and scissor settings are not applied.
    ///
    ///          The render target view must be bound to the pipeline for clear operation to be performed in OpenGL backend.
    ///
    /// \remarks When StateTransitionMode is Diligent::RESOURCE_STATE_TRANSITION_MODE_TRANSITION, the method will 
    ///          transition the texture to the state required by the command. Resource state transitioning is not 
    ///          thread safe, so no other thread is allowed to read or write the states of the same textures.
    ///
    ///          If the application intends to use the same resource in other threads simultaneously, it needs to 
    ///          explicitly manage the states using IDeviceContext::TransitionResourceStates() method.
    ///
    /// \note    In D3D12 backend clearing render targets requires textures to always be transitioned to 
    ///          Diligent::RESOURCE_STATE_RENDER_TARGET state. In Vulkan backend however this depends on whether a 
    ///          render pass has been started. To clear render target outside of a render pass, the texture must be transitioned to
    ///          Diligent::RESOURCE_STATE_COPY_DEST state. Inside a render pass it must be in Diligent::RESOURCE_STATE_RENDER_TARGET
    ///          state. When using Diligent::RESOURCE_STATE_TRANSITION_TRANSITION mode, the engine takes care of proper
    ///          resource state transition, otherwise it is the responsibility of the application.
    ///
    /// \remarks Supported contexts: graphics.
    void* ClearRenderTarget(IDeviceContext*,
                                           ITextureView*                  pView,
                                           const(float)*                   RGBA, 
                                           RESOURCE_STATE_TRANSITION_MODE StateTransitionMode);


    /// Finishes recording commands and generates a command list.
    
    /// \param [out] ppCommandList - Memory location where pointer to the recorded command list will be written.
    void* FinishCommandList(IDeviceContext*, ICommandList** ppCommandList);


    /// Submits an array of recorded command lists for execution.

    /// \param [in] NumCommandLists - The number of command lists to execute.
    /// \param [in] ppCommandLists  - Pointer to the array of NumCommandLists command lists to execute.
    /// \remarks After a command list is executed, it is no longer valid and must be released.
    void* ExecuteCommandLists(IDeviceContext*,
                                             uint               NumCommandLists,
                                             const ICommandList** ppCommandLists);


    /// Tells the GPU to set a fence to a specified value after all previous work has completed.

    /// \param [in] pFence - The fence to signal.
    /// \param [in] Value  - The value to set the fence to. This value must be greater than the
    ///                      previously signaled value on the same fence.
    /// 
    /// \note The method does not flush the context (an application can do this explcitly if needed)
    ///       and the fence will be signaled only when the command context is flushed next time.
    ///       If an application needs to wait for the fence in a loop, it must flush the context
    ///       after signalling the fence.
    ///
    /// \note In Direct3D11 backend, the access to the fence is not thread-safe and
    ///       must be externally synchronized.
    ///       In Direct3D12 and Vulkan backends, the access to the fence is thread-safe.
    void* EnqueueSignal(IDeviceContext*,
                                       IFence*    pFence,
                                       ulong     Value);


    /// Waits until the specified fence reaches or exceeds the specified value, on the device.

    /// \param [in] pFence - The fence to wait. Fence must be created with type FENCE_TYPE_GENERAL.
    /// \param [in] Value  - The value that the context is waiting for the fence to reach.
    ///
    /// \note  If NativeFence feature is not enabled (see Diligent::DeviceFeatures) then
    ///        Value must be less than or equal to the last signaled or pending value.
    ///        Value becomes pending when the context is flushed.
    ///        Waiting for a value that is greater than any pending value will cause a deadlock.
    ///
    /// \note  If NativeFence feature is enabled then waiting for a value that is greater than
    ///        any pending value will cause a GPU stall.
    ///
    /// \note  Direct3D12 and Vulkan backend: access to the fence is thread-safe.
    ///
    /// \remarks  Wait is only allowed for immediate contexts.
    void* DeviceWaitForFence(IDeviceContext*,
                                            IFence*  pFence,
                                            ulong   Value);

    /// Submits all outstanding commands for execution to the GPU and waits until they are complete.

    /// \note The method blocks the execution of the calling thread until the wait is complete.
    ///
    /// \remarks    Only immediate contexts can be idled.\n
    ///             The methods implicitly flushes the context (see IDeviceContext::Flush()), so an 
    ///             application must explicitly reset the PSO and bind all required shader resources after 
    ///             idling the context.\n
    void* WaitForIdle(IDeviceContext*);


    /// Marks the beginning of a query.

    /// \param [in] pQuery - A pointer to a query object.
    ///
    /// \remarks    Only immediate contexts can begin a query.
    ///
    ///             Vulkan requires that a query must either begin and end inside the same
    ///             subpass of a render pass instance, or must both begin and end outside of
    ///             a render pass instance. This means that an application must either begin
    ///             and end a query while preserving render targets, or begin it when no render
    ///             targets are bound to the context. In the latter case the engine will automatically
    ///             end the render pass, if needed, when the query is ended.
    ///             Also note that resource transitions must be performed outside of a render pass,
    ///             and may thus require ending current render pass.
    ///             To explicitly end current render pass, call
    ///             SetRenderTargets(0, nullptr, nullptr, RESOURCE_STATE_TRANSITION_MODE_NONE).
    ///
    /// \warning    OpenGL and Vulkan do not support nested queries of the same type.
    ///
    /// \remarks    On some devices, queries for a single draw or dispatch command may not be supported.
    ///             In this case, the query will begin at the next available moment (for example,
    ///             when the next render pass begins or ends).
    ///
    /// \remarks Supported contexts for graphics queries: graphics.
    ///          Supported contexts for time queries:     graphics, compute.
    void* BeginQuery(IDeviceContext*, IQuery* pQuery);


    /// Marks the end of a query.

    /// \param [in] pQuery - A pointer to a query object.
    ///
    /// \remarks    A query must be ended by the same context that began it.
    ///
    ///             In Direct3D12 and Vulkan, queries (except for timestamp queries)
    ///             cannot span command list boundaries, so the engine will never flush
    ///             the context even if the number of commands exceeds the user-specified limit
    ///             when there is an active query.
    ///             It is an error to explicitly flush the context while a query is active. 
    ///
    ///             All queries must be ended when IDeviceContext::FinishFrame() is called.
    ///
    /// \remarks Supported contexts: graphics, compute.
    void* EndQuery(IDeviceContext*, IQuery* pQuery);


    /// Submits all pending commands in the context for execution to the command queue.

    /// \remarks    Only immediate contexts can be flushed.\n
    ///             Internally the method resets the state of the current command list/buffer.
    ///             When the next draw command is issued, the engine will restore all states 
    ///             (rebind render targets and depth-stencil buffer as well as index and vertex buffers,
    ///             restore viewports and scissor rects, etc.) except for the pipeline state and shader resource
    ///             bindings. An application must explicitly reset the PSO and bind all required shader 
    ///             resources after flushing the context.
    void* Flush(IDeviceContext*);


    /// Updates the data in the buffer.

    /// \param [in] pBuffer             - Pointer to the buffer to update.
    /// \param [in] Offset              - Offset in bytes from the beginning of the buffer to the update region.
    /// \param [in] Size                - Size in bytes of the data region to update.
    /// \param [in] pData               - Pointer to the data to write to the buffer.
    /// \param [in] StateTransitionMode - Buffer state transition mode (see Diligent::RESOURCE_STATE_TRANSITION_MODE)
    ///
    /// \remarks Supported contexts: graphics, compute, transfer.
    void* UpdateBuffer(IDeviceContext*,
                                      IBuffer*                       pBuffer,
                                      uint                         Offset,
                                      uint                         Size,
                                      const void*                    pData,
                                      RESOURCE_STATE_TRANSITION_MODE StateTransitionMode);


    /// Copies the data from one buffer to another.

    /// \param [in] pSrcBuffer              - Source buffer to copy data from.
    /// \param [in] SrcOffset               - Offset in bytes from the beginning of the source buffer to the beginning of data to copy.
    /// \param [in] SrcBufferTransitionMode - State transition mode of the source buffer (see Diligent::RESOURCE_STATE_TRANSITION_MODE).
    /// \param [in] pDstBuffer              - Destination buffer to copy data to.
    /// \param [in] DstOffset               - Offset in bytes from the beginning of the destination buffer to the beginning 
    ///                                       of the destination region.
    /// \param [in] Size                    - Size in bytes of data to copy.
    /// \param [in] DstBufferTransitionMode - State transition mode of the destination buffer (see Diligent::RESOURCE_STATE_TRANSITION_MODE).
    ///
    /// \remarks Supported contexts: graphics, compute, transfer.
    void* CopyBuffer(IDeviceContext*,
                                    IBuffer*                       pSrcBuffer,
                                    uint                           SrcOffset,
                                    RESOURCE_STATE_TRANSITION_MODE SrcBufferTransitionMode,
                                    IBuffer*                       pDstBuffer,
                                    uint                           DstOffset,
                                    uint                           Size,
                                    RESOURCE_STATE_TRANSITION_MODE DstBufferTransitionMode);


    /// Maps the buffer.

    /// \param [in] pBuffer      - Pointer to the buffer to map.
    /// \param [in] MapType      - Type of the map operation. See Diligent::MAP_TYPE.
    /// \param [in] MapFlags     - Special map flags. See Diligent::MAP_FLAGS.
    /// \param [out] pMappedData - Reference to the void pointer to store the address of the mapped region.
    ///
    /// \remarks Supported contexts: graphics, compute, transfer.
    void* MapBuffer(IDeviceContext*,
                                   IBuffer*     pBuffer,
                                   MAP_TYPE     MapType,
                                   MAP_FLAGS    MapFlags,
                                   void**       ppMappedData);


    /// Unmaps the previously mapped buffer.

    /// \param [in] pBuffer - Pointer to the buffer to unmap.
    /// \param [in] MapType - Type of the map operation. This parameter must match the type that was 
    ///                       provided to the Map() method. 
    ///
    /// \remarks Supported contexts: graphics, compute, transfer.
    void* UnmapBuffer(IDeviceContext*,
                                     IBuffer*   pBuffer,
                                     MAP_TYPE   MapType);


    /// Updates the data in the texture.

    /// \param [in] pTexture    - Pointer to the device context interface to be used to perform the operation.
    /// \param [in] MipLevel    - Mip level of the texture subresource to update.
    /// \param [in] Slice       - Array slice. Should be 0 for non-array textures.
    /// \param [in] DstBox      - Destination region on the texture to update.
    /// \param [in] SubresData  - Source data to copy to the texture.
    /// \param [in] SrcBufferTransitionMode - If pSrcBuffer member of TextureSubResData structure is not null, this 
    ///                                       parameter defines state transition mode of the source buffer. 
    ///                                       If pSrcBuffer is null, this parameter is ignored.
    /// \param [in] TextureTransitionMode   - Texture state transition mode (see Diligent::RESOURCE_STATE_TRANSITION_MODE)
    ///
    /// \remarks Supported contexts: graphics, compute, transfer.
    void* UpdateTexture(IDeviceContext*,
                                       ITexture*                        pTexture,
                                       uint                           MipLevel,
                                       uint                           Slice,
                                       const Box*                    DstBox,
                                       const TextureSubResData*      SubresData,
                                       RESOURCE_STATE_TRANSITION_MODE   SrcBufferTransitionMode,
                                       RESOURCE_STATE_TRANSITION_MODE   TextureTransitionMode);


    /// Copies data from one texture to another.

    /// \param [in] CopyAttribs - Structure describing copy command attributes, see Diligent::CopyTextureAttribs for details.
    ///
    /// \remarks Supported contexts: graphics, compute, transfer.
    void* CopyTexture(IDeviceContext*, const CopyTextureAttribs* CopyAttribs);


    /// Maps the texture subresource.

    /// \param [in] pTexture    - Pointer to the texture to map.
    /// \param [in] MipLevel    - Mip level to map.
    /// \param [in] ArraySlice  - Array slice to map. This parameter must be 0 for non-array textures.
    /// \param [in] MapType     - Type of the map operation. See Diligent::MAP_TYPE.
    /// \param [in] MapFlags    - Special map flags. See Diligent::MAP_FLAGS.
    /// \param [in] pMapRegion  - Texture region to map. If this parameter is null, the entire subresource is mapped.
    /// \param [out] MappedData - Mapped texture region data
    ///
    /// \remarks This method is supported in D3D11, D3D12 and Vulkan backends. In D3D11 backend, only the entire 
    ///          subresource can be mapped, so pMapRegion must either be null, or cover the entire subresource.
    ///          In D3D11 and Vulkan backends, dynamic textures are no different from non-dynamic textures, and mapping 
    ///          with MAP_FLAG_DISCARD has exactly the same behavior.
    ///
    /// \remarks Supported contexts: graphics, compute, transfer.
    void* MapTextureSubresource(IDeviceContext*,
                                               ITexture*                    pTexture,
                                               uint                       MipLevel,
                                               uint                       ArraySlice,
                                               MAP_TYPE                     MapType,
                                               MAP_FLAGS                    MapFlags,
                                               const Box*                   pMapRegion,
                                               MappedTextureSubresource* MappedData);


    /// Unmaps the texture subresource.

    /// \param [in] pTexture    - Pointer to the texture to unmap.
    /// \param [in] MipLevel    - Mip level to unmap.
    /// \param [in] ArraySlice  - Array slice to unmap. This parameter must be 0 for non-array textures.
    /// 
    /// \remarks Supported contexts: graphics, compute, transfer.
    void* UnmapTextureSubresource(IDeviceContext*,
                                                 ITexture* pTexture,
                                                 uint    MipLevel,
                                                 uint    ArraySlice);


    /// Generates a mipmap chain.

    /// \param [in] pTextureView - Texture view to generate mip maps for.
    /// \remarks This function can only be called for a shader resource view.
    ///          The texture must be created with MISC_TEXTURE_FLAG_GENERATE_MIPS flag.
    ///
    /// \remarks Supported contexts: graphics.
    void* GenerateMips(IDeviceContext*, ITextureView* pTextureView);


    /// Finishes the current frame and releases dynamic resources allocated by the context.

    /// For immediate context, this method is called automatically by ISwapChain::Present() of the primary
    /// swap chain, but can also be called explicitly. For deferred contexts, the method must be called by the
    /// application to release dynamic resources. The method has some overhead, so it is better to call it once
    /// per frame, though it can be called with different frequency. Note that unless the GPU is idled,
    /// the resources may actually be released several frames after the one they were used in last time.
    /// \note After the call all dynamic resources become invalid and must be written again before the next use. 
    ///       Also, all committed resources become invalid.\n
    ///       For deferred contexts, this method must be called after all command lists referencing dynamic resources
    ///       have been executed through immediate context.\n
    ///       The method does not Flush() the context.
    void* FinishFrame(IDeviceContext*);


    /// Returns the current frame number.

    /// \note The frame number is incremented every time FinishFrame() is called.
    ulong* GetFrameNumber(IDeviceContext*);


    /// Transitions resource states.

    /// \param [in] BarrierCount      - Number of barriers in pResourceBarriers array
    /// \param [in] pResourceBarriers - Pointer to the array of resource barriers
    /// \remarks When both old and new states are RESOURCE_STATE_UNORDERED_ACCESS, the engine
    ///          executes UAV barrier on the resource. The barrier makes sure that all UAV accesses 
    ///          (reads or writes) are complete before any future UAV accesses (read or write) can begin.\n
    ///
    ///          There are two main usage scenarios for this method:
    ///          1. An application knows specifics of resource state transitions not available to the engine.
    ///             For example, only single mip level needs to be transitioned.
    ///          2. An application manages resource states in multiple threads in parallel.
    ///
    ///          The method always reads the states of all resources to transition. If the state of a resource is managed
    ///          by multiple threads in parallel, the resource must first be transitioned to unknown state
    ///          (Diligent::RESOURCE_STATE_UNKNOWN) to disable automatic state management in the engine.
    ///
    ///          When StateTransitionDesc::UpdateResourceState is set to true, the method may update the state of the
    ///          corresponding resource which is not thread safe. No other threads should read or write the state of that 
    ///          resource.
    ///
    /// \note  Resource states for shader access (e.g. RESOURCE_STATE_CONSTANT_BUFFER, RESOURCE_STATE_UNORDERED_ACCESS, RESOURCE_STATE_SHADER_RESOURCE)
    ///        may map to different native state depending on what context type is used (see DeviceContextDesc::ContextType).
    ///        To synchronize write access in compute shader in compute context with a pixel shader read in graphics context, an
    ///        application should call TransitionResourceStates() in graphics context.
    ///        Using TransitionResourceStates() with NewState = RESOURCE_STATE_SHADER_RESOURCE will not invalidate cache in graphics shaders
    ///        and may cause undefined behaviour.
    void* TransitionResourceStates(IDeviceContext*,
                                                  uint                     BarrierCount,
                                                  const StateTransitionDesc* pResourceBarriers);


    /// Resolves a multi-sampled texture subresource into a non-multi-sampled texture subresource.

    /// \param [in] pSrcTexture    - Source multi-sampled texture.
    /// \param [in] pDstTexture    - Destination non-multi-sampled texture.
    /// \param [in] ResolveAttribs - Resolve command attributes, see Diligent::ResolveTextureSubresourceAttribs for details.
    ///
    /// \remarks Supported contexts: graphics.
    void* ResolveTextureSubresource(IDeviceContext*,
                                                   ITexture*                                  pSrcTexture,
                                                   ITexture*                                  pDstTexture,
                                                   const ResolveTextureSubresourceAttribs* ResolveAttribs);
    

    /// Builds a bottom-level acceleration structure with the specified geometries.

    /// \param [in] Attribs - Structure describing build BLAS command attributes, see Diligent::BuildBLASAttribs for details.
    /// 
    /// \note Don't call build or copy operation on the same BLAS in a different contexts, because BLAS has CPU-side data
    ///       that will not match with GPU-side, so shader binding were incorrect.
    ///
    /// \remarks Supported contexts: graphics, compute.
    void* BuildBLAS(IDeviceContext*, const BuildBLASAttribs* Attribs);
    

    /// Builds a top-level acceleration structure with the specified instances.

    /// \param [in] Attribs - Structure describing build TLAS command attributes, see Diligent::BuildTLASAttribs for details.
    /// 
    /// \note Don't call build or copy operation on the same TLAS in a different contexts, because TLAS has CPU-side data
    ///       that will not match with GPU-side, so shader binding were incorrect.
    ///
    /// \remarks Supported contexts: graphics, compute.
    void* BuildTLAS(IDeviceContext*, const BuildTLASAttribs* Attribs);
    

    /// Copies data from one acceleration structure to another.

    /// \param [in] Attribs - Structure describing copy BLAS command attributes, see Diligent::CopyBLASAttribs for details.
    /// 
    /// \note Don't call build or copy operation on the same BLAS in a different contexts, because BLAS has CPU-side data
    ///       that will not match with GPU-side, so shader binding were incorrect.
    ///
    /// \remarks Supported contexts: graphics, compute.
    void* CopyBLAS(IDeviceContext*, const CopyBLASAttribs* Attribs);
    

    /// Copies data from one acceleration structure to another.

    /// \param [in] Attribs - Structure describing copy TLAS command attributes, see Diligent::CopyTLASAttribs for details.
    /// 
    /// \note Don't call build or copy operation on the same TLAS in a different contexts, because TLAS has CPU-side data
    ///       that will not match with GPU-side, so shader binding were incorrect.
    ///
    /// \remarks Supported contexts: graphics, compute.
    void* CopyTLAS(IDeviceContext*, const CopyTLASAttribs* Attribs);
    

    /// Writes a bottom-level acceleration structure memory size required for compacting operation to a buffer.

    /// \param [in] Attribs - Structure describing write BLAS compacted size command attributes, see Diligent::WriteBLASCompactedSizeAttribs for details.
    ///
    /// \remarks Supported contexts: graphics, compute.
    void* WriteBLASCompactedSize(IDeviceContext*, const WriteBLASCompactedSizeAttribs* Attribs);
    

    /// Writes a top-level acceleration structure memory size required for compacting operation to a buffer.

    /// \param [in] Attribs - Structure describing write TLAS compacted size command attributes, see Diligent::WriteTLASCompactedSizeAttribs for details.
    ///
    /// \remarks Supported contexts: graphics, compute.
    void* WriteTLASCompactedSize(IDeviceContext*, const WriteTLASCompactedSizeAttribs* Attribs);
    

    /// Executes a trace rays command.
    
    /// \param [in] Attribs - Trace rays command attributes, see Diligent::TraceRaysAttribs for details.
    ///
    /// \remarks  The method is not thread-safe. An application must externally synchronize the access
    ///           to the shader binding table (SBT) passed as an argument to the function.
    ///           The function does not modify the state of the SBT and can be executed in parallel with other
    ///           functions that don't modify the SBT (e.g. TraceRaysIndirect).
    ///
    /// \remarks Supported contexts: graphics, compute.
    void* TraceRays(IDeviceContext*, const TraceRaysAttribs* Attribs);
    

    /// Executes an indirect trace rays command.
    
    /// \param [in] pAttribsBuffer - Pointer to the buffer containing indirect trace rays attributes.
    ///                              The buffer must contain the following arguments at the specified offset:
    ///                                 [88 bytes reserved] - for Direct3D12 backend
    ///                                 uint DimensionX;
    ///                                 uint DimensionY;
    ///                                 uint DimensionZ;
    ///                              You must call IDeviceContext::UpdateSBT() to initialize the first 88 bytes with the
    ///                              same shader binding table as specified in TraceRaysIndirectAttribs::pSBT.
    /// 
    /// \remarks  The method is not thread-safe. An application must externally synchronize the access
    ///           to the shader binding table (SBT) passed as an argument to the function.
    ///           The function does not modify the state of the SBT and can be executed in parallel with other
    ///           functions that don't modify the SBT (e.g. TraceRays).
    ///
    /// \remarks Supported contexts: graphics, compute.
    void* TraceRaysIndirect(IDeviceContext*,
                                           const TraceRaysIndirectAttribs* Attribs,
                                           IBuffer*                           pAttribsBuffer);


    /// Updates SBT with the pending data that were recorded in IShaderBindingTable::Bind*** calls.

    /// \param [in] pSBT                         - Shader binding table that will be updated if there are pending data.
    /// \param [in] pUpdateIndirectBufferAttribs - Indirect ray tracing attributes buffer update attributes (optional, may be null).
    /// 
    /// \note  When pUpdateIndirectBufferAttribs is not null, the indirect ray tracing attributes will be written to the pAttribsBuffer buffer
    ///        specified by the structure and can be used by IDeviceContext::TraceRaysIndirect() command.
    ///        In Direct3D12 backend, the pAttribsBuffer buffer will be initialized with D3D12_DISPATCH_RAYS_DESC structure that contains
    ///        GPU addresses of the ray tracing shaders in the first 88 bytes and 12 bytes for dimension
    ///        (see IDeviceContext::TraceRaysIndirect() description).
    ///        In Vulkan backend, the pAttribsBuffer buffer will not be modified, because the SBT is used directly
    ///        in IDeviceContext::TraceRaysIndirect().
    /// 
    /// \remarks  The method is not thread-safe. An application must externally synchronize the access
    ///           to the shader binding table (SBT) passed as an argument to the function.
    ///           The function modifies the data in the SBT and must not run in parallel with any other command that uses the same SBT.
    ///
    /// \remarks Supported contexts: graphics, compute, transfer.
    void* UpdateSBT(IDeviceContext*,
                                   IShaderBindingTable*                 pSBT,
                                   const UpdateIndirectRTBufferAttribs* pUpdateIndirectBufferAttribs = null);


    /// Stores a pointer to the user-provided data object, which
    /// may later be retrieved through GetUserData().
    ///
    /// \param [in] pUserData - Pointer to the user data object to store.
    ///
    /// \note   The method is not thread-safe and an application
    ///         must externally synchronize the access.
    ///
    ///         The method keeps strong reference to the user data object.
    ///         If an application needs to release the object, it
    ///         should call SetUserData(nullptr);
    void* SetUserData(IDeviceContext*, IObject* pUserData);


    /// Returns a pointer to the user data object previously
    /// set with SetUserData() method.
    ///
    /// \return     The pointer to the user data object.
    ///
    /// \remarks    The method does *NOT* call AddRef()
    ///             for the object being returned.
    IObject** GetUserData(IDeviceContext*);


    /// Begins a debug group with name and color.
    /// External debug tools may use this information when displaying context commands.

    /// \param [in] Name   - Group name.
    /// \param [in] pColor - Region color.
    ///
    /// \remarks Supported contexts: graphics, compute, transfer.
    void* BeginDebugGroup(IDeviceContext*,
                                        const(char)*  Name,
                                        const(float)* pColor = null);

    /// Ends a debug group that was previously started with IDeviceContext::BeginDebugGroup.
    void* EndDebugGroup(IDeviceContext*);


    /// Inserts a debug label with name and color.
    /// External debug tools may use this information when displaying context commands.

    /// \param [in] Label  - Label name.
    /// \param [in] pColor - Label color.
    ///
    /// \remarks Supported contexts: graphics, compute, transfer.
    ///          Not supported in Metal backend.
    void* InsertDebugLabel(IDeviceContext*,
                                          const(char)*  Label,
                                          const(float)* pColor = null);

    /// Locks the internal mutex and returns a pointer to the command queue that is associated with this device context.

    /// \return - a pointer to ICommandQueue interface of the command queue associated with the context.
    ///
    /// \remarks  Only immediate device contexts have associated command queues.
    ///
    ///           The engine locks the internal mutex to prevent simultaneous access to the command queue.
    ///           An application must release the lock by calling IDeviceContext::UnlockCommandQueue()
    ///           when it is done working with the queue or the engine will not be able to submit any command
    ///           list to the queue. Nested calls to LockCommandQueue() are not allowed.
    ///           The queue pointer never changes while the context is alive, so an application may cache and
    ///           use the pointer if it does not need to prevent potential simultaneous access to the queue from
    ///           other threads.
    ///
    ///           The engine manages the lifetimes of command queues and all other device objects,
    ///           so an application must not call AddRef/Release methods on the returned interface.
    ICommandQueue** LockCommandQueue(IDeviceContext*);

    /// Unlocks the command queue that was previously locked by IDeviceContext::LockCommandQueue().
    void* UnlockCommandQueue(IDeviceContext*);
}

struct IDeviceContextVtbl { IDeviceContextMethods DeviceContext; }
struct IDeviceContext { IDeviceContextVtbl* pVtbl; }

const(DeviceContextDesc)** IDeviceContext_GetDesc(IDeviceContext* context) {
    return context.pVtbl.DeviceContext.GetDesc(context);
}

void*  IDeviceContext_Begin(IDeviceContext* context, uint immediateContextId) {
    return context.pVtbl.DeviceContext.Begin(context, immediateContextId);
}

void*  IDeviceContext_SetPipelineState(IDeviceContext* context, IPipelineState* pPipelineState) {
    return context.pVtbl.DeviceContext.SetPipelineState(context, pPipelineState);
}

void*  IDeviceContext_TransitionShaderResources(IDeviceContext* context, 
                                                   IPipelineState*         pPipelineState, 
                                                   IShaderResourceBinding* pShaderResourceBinding) {
    return context.pVtbl.DeviceContext.TransitionShaderResources(context, pPipelineState, pShaderResourceBinding);
}

void*  IDeviceContext_CommitShaderResources(IDeviceContext* context,
                                               IShaderResourceBinding*        pShaderResourceBinding,
                                               RESOURCE_STATE_TRANSITION_MODE stateTransitionMode) {
    return context.pVtbl.DeviceContext.CommitShaderResources(context, pShaderResourceBinding, stateTransitionMode);
}

void*  IDeviceContext_SetStencilRef(IDeviceContext* context, uint stencilRef) {
    return context.pVtbl.DeviceContext.SetStencilRef(context, stencilRef);
}

void*  IDeviceContext_SetBlendFactors(IDeviceContext* context, const(float)* pBlendFactors = null) {
    return context.pVtbl.DeviceContext.SetBlendFactors(context, pBlendFactors);
}

void*  IDeviceContext_SetVertexBuffers(IDeviceContext* context,
                                          uint                           startSlot, 
                                          uint                           numBuffersSet, 
                                          IBuffer**                      ppBuffers, 
                                          const uint*                    pOffsets,
                                          RESOURCE_STATE_TRANSITION_MODE stateTransitionMode,
                                          SET_VERTEX_BUFFERS_FLAGS       flags) {
    return context.pVtbl.DeviceContext.SetVertexBuffers(context, startSlot, numBuffersSet, ppBuffers, pOffsets, stateTransitionMode, flags);
}

void*  IDeviceContext_InvalidateState(IDeviceContext* context) {
    return context.pVtbl.DeviceContext.InvalidateState(context);
}

void*  IDeviceContext_SetIndexBuffer(IDeviceContext* context,
                                        IBuffer*                       pIndexBuffer,
                                        uint                           byteOffset,
                                        RESOURCE_STATE_TRANSITION_MODE stateTransitionMode) {
    return context.pVtbl.DeviceContext.SetIndexBuffer(context, pIndexBuffer, byteOffset, stateTransitionMode);
}

void*  IDeviceContext_SetViewports(IDeviceContext* context,
                                      uint            numViewports,
                                      const(Viewport)* pViewports, 
                                      uint            rtWidth, 
                                      uint            rtHeight) {
    return context.pVtbl.DeviceContext.SetViewports(context, numViewports, pViewports, rtWidth, rtHeight);
}

void*  IDeviceContext_SetScissorRects(IDeviceContext* context,
                                         uint        numRects,
                                         const(Rect)* pRects,
                                         uint        rtWidth,
                                         uint        rtHeight) {
    return context.pVtbl.DeviceContext.SetScissorRects(context, numRects, pRects, rtWidth, rtHeight);
}

void*  IDeviceContext_SetRenderTargets(IDeviceContext* context,
                                          uint                           numRenderTargets,
                                          ITextureView*[]                ppRenderTargets,
                                          ITextureView*                  pDepthStencil,
                                          RESOURCE_STATE_TRANSITION_MODE stateTransitionMode) {
    return context.pVtbl.DeviceContext.SetRenderTargets(context, numRenderTargets, ppRenderTargets, pDepthStencil, stateTransitionMode);
}

void*  IDeviceContext_BeginRenderPass(IDeviceContext* context, const(BeginRenderPassAttribs)* attribs) {
    return context.pVtbl.DeviceContext.BeginRenderPass(context, attribs);
}

void*  IDeviceContext_NextSubpass(IDeviceContext* context) {
    return context.pVtbl.DeviceContext.NextSubpass(context);
}

void*  IDeviceContext_EndRenderPass(IDeviceContext* context) {
    return context.pVtbl.DeviceContext.EndRenderPass(context);
}

void*  IDeviceContext_Draw(IDeviceContext* context, const(DrawAttribs)* attribs) {
    return context.pVtbl.DeviceContext.Draw(context, attribs);
}

void*  IDeviceContext_DrawIndexed(IDeviceContext* context, const(DrawIndexedAttribs)* attribs) {
    return context.pVtbl.DeviceContext.DrawIndexed(context, attribs);
}

void*  IDeviceContext_DrawIndirect(IDeviceContext* context,
                                      const(DrawIndirectAttribs)* attribs,
                                      IBuffer*                    pAttribsBuffer) {
    return context.pVtbl.DeviceContext.DrawIndirect(context, attribs, pAttribsBuffer);
}

void*  IDeviceContext_DrawIndexedIndirect(IDeviceContext* context,
                                             const(DrawIndexedIndirectAttribs)*  attribs,
                                             IBuffer*                            pAttribsBuffer) {
    return context.pVtbl.DeviceContext.DrawIndexedIndirect(context, attribs, pAttribsBuffer);
}

void*  IDeviceContext_DrawMesh(IDeviceContext* context, const(DrawMeshAttribs)* attribs) {
    return context.pVtbl.DeviceContext.DrawMesh(context, attribs);
}

void*  IDeviceContext_DrawMeshIndirect(IDeviceContext* context,
                                          const(DrawMeshIndirectAttribs)* attribs,
                                          IBuffer*                        pAttribsBuffer) {
    return context.pVtbl.DeviceContext.DrawMeshIndirect(context, attribs, pAttribsBuffer);
}

void*  IDeviceContext_DrawMeshIndirectCount(IDeviceContext* context,
                                               const(DrawMeshIndirectCountAttribs)* attribs,
                                               IBuffer*                             pAttribsBuffer,
                                               IBuffer*                             pCountBuffer) {
    return context.pVtbl.DeviceContext.DrawMeshIndirectCount(context, attribs, pAttribsBuffer, pCountBuffer);
}

void*  IDeviceContext_DispatchCompute(IDeviceContext* context, const(DispatchComputeAttribs)* attribs) {
    return context.pVtbl.DeviceContext.DispatchCompute(context, attribs);
}

void*  IDeviceContext_DispatchComputeIndirect(IDeviceContext* context,
                                                 const(DispatchComputeIndirectAttribs)* attribs,
                                                 IBuffer*                               pAttribsBuffer) {
    return context.pVtbl.DeviceContext.DispatchComputeIndirect(context, attribs, pAttribsBuffer);
}

void*  IDeviceContext_DispatchTile(IDeviceContext* context, const(DispatchTileAttribs)* attribs) {
    return context.pVtbl.DeviceContext.DispatchTile(context, attribs);
}

void*  IDeviceContext_GetTileSize(IDeviceContext* context, uint* sizeX, uint* sizeY) {
    return context.pVtbl.DeviceContext.GetTileSize(context, sizeX, sizeY);
}

void*  IDeviceContext_ClearDepthStencil(IDeviceContext* context,
                                           ITextureView*                  pView,
                                           CLEAR_DEPTH_STENCIL_FLAGS      clearFlags,
                                           float                          fDepth,
                                           ubyte                          stencil,
                                           RESOURCE_STATE_TRANSITION_MODE stateTransitionMode) {
    return context.pVtbl.DeviceContext.ClearDepthStencil(context, pView, clearFlags, fDepth, stencil, stateTransitionMode);
}

void*  IDeviceContext_ClearRenderTarget(IDeviceContext* context,
                                           ITextureView*                  pView,
                                           const(float)*                  rgba, 
                                           RESOURCE_STATE_TRANSITION_MODE stateTransitionMode) {
    return context.pVtbl.DeviceContext.ClearRenderTarget(context, pView, rgba, stateTransitionMode);
}

void*  IDeviceContext_FinishCommandList(IDeviceContext* context, ICommandList** ppCommandList) {
    return context.pVtbl.DeviceContext.FinishCommandList(context, ppCommandList);
}

void*  IDeviceContext_ExecuteCommandLists(IDeviceContext* context,
                                             uint                 numCommandLists,
                                             const ICommandList** ppCommandLists) {
    return context.pVtbl.DeviceContext.ExecuteCommandLists(context, numCommandLists, ppCommandLists);
}

void*  IDeviceContext_EnqueueSignal(IDeviceContext* context,
                                       IFence*   pFence,
                                       ulong     value) {
    return context.pVtbl.DeviceContext.EnqueueSignal(context, pFence, value);
}

void*  IDeviceContext_DeviceWaitForFence(IDeviceContext* context,
                                            IFence*  pFence,
                                            ulong    value) {
    return context.pVtbl.DeviceContext.DeviceWaitForFence(context, pFence, value);
}

void*  IDeviceContext_WaitForIdle(IDeviceContext* context) {
    return context.pVtbl.DeviceContext.WaitForIdle(context);
}

void*  IDeviceContext_BeginQuery(IDeviceContext* context, IQuery* pQuery) {
    return context.pVtbl.DeviceContext.BeginQuery(context, pQuery);
}

void*  IDeviceContext_EndQuery(IDeviceContext* context, IQuery* pQuery) {
    return context.pVtbl.DeviceContext.EndQuery(context, pQuery);
}

void*  IDeviceContext_Flush(IDeviceContext* context) {
    return context.pVtbl.DeviceContext.Flush(context);
}

void*  IDeviceContext_UpdateBuffer(IDeviceContext* context,
                                      IBuffer*                       pBuffer,
                                      uint                           offset,
                                      uint                           size,
                                      const(void)*                    pData,
                                      RESOURCE_STATE_TRANSITION_MODE stateTransitionMode) {
    return context.pVtbl.DeviceContext.UpdateBuffer(context, pBuffer, offset, size, pData, stateTransitionMode);
}

void*  IDeviceContext_CopyBuffer(IDeviceContext* context,
                                    IBuffer*                       pSrcBuffer,
                                    uint                           srcOffset,
                                    RESOURCE_STATE_TRANSITION_MODE srcBufferTransitionMode,
                                    IBuffer*                       pDstBuffer,
                                    uint                           dstOffset,
                                    uint                           size,
                                    RESOURCE_STATE_TRANSITION_MODE dstBufferTransitionMode) {
    return context.pVtbl.DeviceContext.CopyBuffer(context, pSrcBuffer, srcOffset, srcBufferTransitionMode, pDstBuffer, dstOffset, size, dstBufferTransitionMode);
}

void*  IDeviceContext_MapBuffer(IDeviceContext* context,
                                   IBuffer*     pBuffer,
                                   MAP_TYPE     mapType,
                                   MAP_FLAGS    mapFlags,
                                   void**       ppMappedData) {
    return context.pVtbl.DeviceContext.MapBuffer(context, pBuffer, mapType, mapFlags, ppMappedData);
}

void*  IDeviceContext_UnmapBuffer(IDeviceContext* context,
                                     IBuffer*   pBuffer,
                                     MAP_TYPE   mapType) {
    return context.pVtbl.DeviceContext.UnmapBuffer(context, pBuffer, mapType);
}

void*  IDeviceContext_UpdateTexture(IDeviceContext* context,
                                       ITexture*                        pTexture,
                                       uint                             mipLevel,
                                       uint                             slice,
                                       const(Box)*                      dstBox,
                                       const(TextureSubResData)*        subresData,
                                       RESOURCE_STATE_TRANSITION_MODE   srcBufferTransitionMode,
                                       RESOURCE_STATE_TRANSITION_MODE   textureTransitionMode) {
    return context.pVtbl.DeviceContext.UpdateTexture(context, pTexture, mipLevel, slice, dstBox, subresData, srcBufferTransitionMode, textureTransitionMode);
}

void*  IDeviceContext_CopyTexture(IDeviceContext* context, const(CopyTextureAttribs)* copyAttribs) {
    return context.pVtbl.DeviceContext.CopyTexture(context, copyAttribs);
}

void*  IDeviceContext_MapTextureSubresource(IDeviceContext* context,
                                               ITexture*                  pTexture,
                                               uint                       mipLevel,
                                               uint                       arraySlice,
                                               MAP_TYPE                   mapType,
                                               MAP_FLAGS                  mapFlags,
                                               const(Box)*                pMapRegion,
                                               MappedTextureSubresource*  mappedData) {
    return context.pVtbl.DeviceContext.MapTextureSubresource(context, pTexture, mipLevel, arraySlice, mapType, mapFlags, pMapRegion, mappedData);
}

void*  IDeviceContext_UnmapTextureSubresource(IDeviceContext* context,
                                                 ITexture* pTexture,
                                                 uint      mipLevel,
                                                 uint      arraySlice) {
    return context.pVtbl.DeviceContext.UnmapTextureSubresource(context, pTexture, mipLevel, arraySlice);
}

void*  IDeviceContext_GenerateMips(IDeviceContext* context, ITextureView* pTextureView) {
    return context.pVtbl.DeviceContext.GenerateMips(context, pTextureView);
}

void*  IDeviceContext_FinishFrame(IDeviceContext* context) {
    return context.pVtbl.DeviceContext.FinishFrame(context);
}

void*  IDeviceContext_GetFrameNumber(IDeviceContext* context) {
    return context.pVtbl.DeviceContext.GetFrameNumber(context);
}

void*  IDeviceContext_TransitionResourceStates(IDeviceContext* context,
                                                  uint                        barrierCount,
                                                  const(StateTransitionDesc)* pResourceBarriers) {
    return context.pVtbl.DeviceContext.TransitionResourceStates(context, barrierCount, pResourceBarriers);
}

void*  IDeviceContext_ResolveTextureSubresource(IDeviceContext* context,
                                                   ITexture*                                  pSrcTexture,
                                                   ITexture*                                  pDstTexture,
                                                   const(ResolveTextureSubresourceAttribs)*   resolveAttribs) {
    return context.pVtbl.DeviceContext.ResolveTextureSubresource(context, pSrcTexture, pDstTexture, resolveAttribs);
}

void*  IDeviceContext_BuildBLAS(IDeviceContext* context, const(BuildBLASAttribs)* attribs) {
    return context.pVtbl.DeviceContext.BuildBLAS(context, attribs);
}

void*  IDeviceContext_BuildTLAS(IDeviceContext* context, const(BuildTLASAttribs)* attribs) {
    return context.pVtbl.DeviceContext.BuildTLAS(context, attribs);
}

void*  IDeviceContext_CopyBLAS(IDeviceContext* context, const(CopyBLASAttribs)* attribs) {
    return context.pVtbl.DeviceContext.CopyBLAS(context, attribs);
}

void*  IDeviceContext_CopyTLAS(IDeviceContext* context, const(CopyTLASAttribs)* attribs) {
    return context.pVtbl.DeviceContext.CopyTLAS(context, attribs);
}

void*  IDeviceContext_WriteBLASCompactedSize(IDeviceContext* context, const(WriteBLASCompactedSizeAttribs)* attribs) {
    return context.pVtbl.DeviceContext.WriteBLASCompactedSize(context, attribs);
}

void*  IDeviceContext_WriteTLASCompactedSize(IDeviceContext* context, const(WriteTLASCompactedSizeAttribs)* attribs) {
    return context.pVtbl.DeviceContext.WriteTLASCompactedSize(context, attribs);
}

void*  IDeviceContext_TraceRays(IDeviceContext* context, const(TraceRaysAttribs)* attribs) {
    return context.pVtbl.DeviceContext.TraceRays(context, attribs);
}

void*  IDeviceContext_TraceRaysIndirect(IDeviceContext* context,
                                           const(TraceRaysIndirectAttribs)* attribs,
                                           IBuffer*                         pAttribsBuffer) {
    return context.pVtbl.DeviceContext.TraceRaysIndirect(context, attribs, pAttribsBuffer);
}

void*  IDeviceContext_UpdateSBT(IDeviceContext* context,
                                   IShaderBindingTable*                 pSBT,
                                   const UpdateIndirectRTBufferAttribs* pUpdateIndirectBufferAttribs = null) {
    return context.pVtbl.DeviceContext.UpdateSBT(context, pSBT, pUpdateIndirectBufferAttribs);
}

void*  IDeviceContext_SetUserData(IDeviceContext* context, IObject* pUserData) {
    return context.pVtbl.DeviceContext.SetUserData(context, pUserData);
}

IObject** IDeviceContext_GetUserData(IDeviceContext* context) {
    return context.pVtbl.DeviceContext.GetUserData(context);
}

void*  IDeviceContext_BeginDebugGroup(IDeviceContext* context,
                                        const(char)*  name,
                                        const(float)* pColour = null) {
    return context.pVtbl.DeviceContext.BeginDebugGroup(context, name, pColour);
}

void*  IDeviceContext_EndDebugGroup(IDeviceContext* context) {
    return context.pVtbl.DeviceContext.EndDebugGroup(context);
}

void*  IDeviceContext_InsertDebugLabel(IDeviceContext* context,
                                        const(char)*  label,
                                        const(float)* pColour = null) {
    return context.pVtbl.DeviceContext.InsertDebugLabel(context, label, pColour);
}

ICommandQueue** IDeviceContext_LockCommandQueue(IDeviceContext* context) {
    return context.pVtbl.DeviceContext.LockCommandQueue(context);
}

void*  IDeviceContext_UnlockCommandQueue(IDeviceContext* context) {
    return context.pVtbl.DeviceContext.UnlockCommandQueue(context);
}
