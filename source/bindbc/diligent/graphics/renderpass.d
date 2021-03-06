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

module bindbc.diligent.graphics.renderpass;

/// \file
/// Definition of the Diligent::IRenderPass interface and related data structures

public import bindbc.diligent.graphics.deviceobject;

// {B818DEC7-174D-447A-A8E4-94D21C57B40A}
static const INTERFACE_ID IID_RenderPass =
    INTERFACE_ID( 0xb818dec7, 0x174d, 0x447a, [ 0xa8, 0xe4, 0x94, 0xd2, 0x1c, 0x57, 0xb4, 0xa ] );

/// Render pass attachment load operation
/// Vulkan counterpart: [VkAttachmentLoadOp](https://www.khronos.org/registry/vulkan/specs/1.1-extensions/html/vkspec.html#VkAttachmentLoadOp).
/// D3D12 counterpart: [D3D12_RENDER_PASS_BEGINNING_ACCESS_TYPE](https://docs.microsoft.com/en-us/windows/win32/api/d3d12/ne-d3d12-d3d12_render_pass_beginning_access_type).
enum ATTACHMENT_LOAD_OP : ubyte
{
    /// The previous contents of the texture within the render area will be preserved.
    /// Vulkan counterpart: VK_ATTACHMENT_LOAD_OP_LOAD.
    /// D3D12 counterpart: D3D12_RENDER_PASS_BEGINNING_ACCESS_TYPE_PRESERVE.
    ATTACHMENT_LOAD_OP_LOAD = 0,

    /// The contents within the render area will be cleared to a uniform value, which is
    /// specified when a render pass instance is begun.
    /// Vulkan counterpart: VK_ATTACHMENT_LOAD_OP_CLEAR.
    /// D3D12 counterpart: D3D12_RENDER_PASS_BEGINNING_ACCESS_TYPE_CLEAR.
    ATTACHMENT_LOAD_OP_CLEAR,

    /// The previous contents within the area need not be preserved; the contents of
    /// the attachment will be undefined inside the render area.
    /// Vulkan counterpart: VK_ATTACHMENT_LOAD_OP_DONT_CARE.
    /// D3D12 counterpart: D3D12_RENDER_PASS_BEGINNING_ACCESS_TYPE_DISCARD.
    ATTACHMENT_LOAD_OP_DISCARD
}

/// Render pass attachment store operation
/// Vulkan counterpart: [VkAttachmentStoreOp](https://www.khronos.org/registry/vulkan/specs/1.1-extensions/html/vkspec.html#VkAttachmentStoreOp).
/// D3D12 counterpart: [D3D12_RENDER_PASS_ENDING_ACCESS_TYPE](https://docs.microsoft.com/en-us/windows/win32/api/d3d12/ne-d3d12-d3d12_render_pass_ending_access_type).
enum ATTACHMENT_STORE_OP : ubyte
{
    /// The contents generated during the render pass and within the render area are written to memory.
    /// Vulkan counterpart: VK_ATTACHMENT_STORE_OP_STORE.
    /// D3D12 counterpart: D3D12_RENDER_PASS_ENDING_ACCESS_TYPE_PRESERVE.
    ATTACHMENT_STORE_OP_STORE = 0,

    /// The contents within the render area are not needed after rendering, and may be discarded;
    /// the contents of the attachment will be undefined inside the render area.
    /// Vulkan counterpart: VK_ATTACHMENT_STORE_OP_DONT_CARE.
    /// D3D12 counterpart: D3D12_RENDER_PASS_ENDING_ACCESS_TYPE_DISCARD.
    ATTACHMENT_STORE_OP_DISCARD
}

/// Render pass attachment description.
struct RenderPassAttachmentDesc
{
    /// The format of the texture view that will be used for the attachment.
    TEXTURE_FORMAT          Format          = TEXTURE_FORMAT.TEX_FORMAT_UNKNOWN;

    /// The number of samples in the texture.
    ubyte                   SampleCount     = 1;

    /// Load operation that specifies how the contents of color and depth components of
    /// the attachment are treated at the beginning of the subpass where it is first used.
    ATTACHMENT_LOAD_OP      LoadOp          = ATTACHMENT_LOAD_OP.ATTACHMENT_LOAD_OP_LOAD;

    /// Store operation how the contents of color and depth components of the attachment
    /// are treated at the end of the subpass where it is last used.
    ATTACHMENT_STORE_OP     StoreOp         = ATTACHMENT_STORE_OP.ATTACHMENT_STORE_OP_STORE;

    /// Load operation that specifies how the contents of the stencil component of the
    /// attachment is treated at the beginning of the subpass where it is first used.
    /// This value is ignored when the format does not have stencil component.
    ATTACHMENT_LOAD_OP      StencilLoadOp   = ATTACHMENT_LOAD_OP.ATTACHMENT_LOAD_OP_LOAD;

    /// Store operation how the contents of the stencil component of the attachment
    /// is treated at the end of the subpass where it is last used.
    /// This value is ignored when the format does not have stencil component.
    ATTACHMENT_STORE_OP     StencilStoreOp  = ATTACHMENT_STORE_OP.ATTACHMENT_STORE_OP_STORE;

    /// The state the attachment texture subresource will be in when a render pass instance begins.
    RESOURCE_STATE          InitialState    = RESOURCE_STATE.RESOURCE_STATE_UNKNOWN;

    /// The state the attachment texture subresource will be transitioned to when a render pass instance ends.
    RESOURCE_STATE          FinalState      = RESOURCE_STATE.RESOURCE_STATE_UNKNOWN;

}

enum ATTACHMENT_UNUSED = (~0U);

/// Attachment reference description.
struct AttachmentReference
{
    /// Either an integer value identifying an attachment at the corresponding index in RenderPassDesc::pAttachments,
    /// or ATTACHMENT_UNUSED to signify that this attachment is not used.
    uint          AttachmentIndex = 0;

    /// The state of the attachment during the subpass.
    RESOURCE_STATE  State         = RESOURCE_STATE.RESOURCE_STATE_UNKNOWN;
}

/// Render pass subpass description.
struct SubpassDesc
{
    /// The number of input attachments the subpass uses.
    uint                      InputAttachmentCount        = 0;

    /// Pointer to the array of input attachments, see Diligent::AttachmentReference.
    const(AttachmentReference)*  pInputAttachments        = null;

    /// The number of color render target attachments.
    uint                      RenderTargetAttachmentCount = 0;;

    /// Pointer to the array of color render target attachments, see Diligent::AttachmentReference.

    /// Each element of the pRenderTargetAttachments array corresponds to an output in the pixel shader,
    /// i.e. if the shader declares an output variable decorated with a render target index X, then it uses
    /// the attachment provided in pRenderTargetAttachments[X]. If the attachment index is ATTACHMENT_UNUSED,
    /// writes to this render target are ignored.
    const(AttachmentReference)*  pRenderTargetAttachments = null;

    /// Pointer to the array of resolve attachments, see Diligent::AttachmentReference.

    /// If pResolveAttachments is not NULL, each of its elements corresponds to a render target attachment
    /// (the element in pRenderTargetAttachments at the same index), and a multisample resolve operation is
    /// defined for each attachment. At the end of each subpass, multisample resolve operations read the subpass's
    /// color attachments, and resolve the samples for each pixel within the render area to the same pixel location
    /// in the corresponding resolve attachments, unless the resolve attachment index is ATTACHMENT_UNUSED.
    const(AttachmentReference)*  pResolveAttachments      = null;

    /// Pointer to the depth-stencil attachment, see Diligent::AttachmentReference.
    const(AttachmentReference)*  pDepthStencilAttachment  = null;

    /// The number of preserve attachments.
    uint                      PreserveAttachmentCount     = 0;

    /// Pointer to the array of preserve attachments, see Diligent::AttachmentReference.
    const(uint)*               pPreserveAttachments       = null;
};

enum SUBPASS_EXTERNAL = (~0U);

/// Subpass dependency description
struct SubpassDependencyDesc
{
    /// The subpass index of the first subpass in the dependency, or SUBPASS_EXTERNAL.
    uint                SrcSubpass      = 0;

    /// The subpass index of the second subpass in the dependency, or SUBPASS_EXTERNAL.
    uint                DstSubpass      = 0;

    /// A bitmask of PIPELINE_STAGE_FLAGS specifying the source stage mask.
    PIPELINE_STAGE_FLAGS  SrcStageMask  = PIPELINE_STAGE_FLAGS.PIPELINE_STAGE_FLAG_UNDEFINED;

    /// A bitmask of PIPELINE_STAGE_FLAGS specifying the destination stage mask.
    PIPELINE_STAGE_FLAGS  DstStageMask  = PIPELINE_STAGE_FLAGS.PIPELINE_STAGE_FLAG_UNDEFINED;

    /// A bitmask of ACCESS_FLAGS specifying a source access mask.
    ACCESS_FLAGS          SrcAccessMask = ACCESS_FLAGS.ACCESS_FLAG_NONE;

    /// A bitmask of ACCESS_FLAGS specifying a destination access mask.
    ACCESS_FLAGS          DstAccessMask = ACCESS_FLAGS.ACCESS_FLAG_NONE;
}

/// Render pass description
struct RenderPassDesc
{
    DeviceObjectAttribs _DeviceObjectAttribs;

    /// The number of attachments used by the render pass.
    uint                           AttachmentCount    = 0;

    /// Pointer to the array of subpass attachments, see Diligent::RenderPassAttachmentDesc.
    const(RenderPassAttachmentDesc)*  pAttachments    = null;

    /// The number of subpasses in the render pass.
    uint                           SubpassCount       = 0;

    /// Pointer to the array of subpass descriptions, see Diligent::SubpassDesc.
    const(SubpassDesc)*               pSubpasses      = null;

    /// The number of memory dependencies between pairs of subpasses.
    uint                           DependencyCount    = 0;

    /// Pointer to the array of subpass dependencies, see Diligent::SubpassDependencyDesc.
    const(SubpassDependencyDesc)*     pDependencies   = null;
}

struct IRenderPassVtbl
{
    IObjectMethods       Object;
    IDeviceObjectMethods DeviceObject;
}

struct IRenderPass { IRenderPassVtbl* pVtbl; }


