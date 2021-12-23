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

module bindbc.diligent.graphics.framebuffer;

/// \file
/// Definition of the Diligent::IFramebuffer interface and related data structures

public import bindbc.diligent.graphics.deviceobject;
public import bindbc.diligent.graphics.renderpass;
public import bindbc.diligent.graphics.textureview;

// {05DA9E47-3CA6-4F96-A967-1DDDC53181A6}
static const INTERFACE_ID IID_Framebuffer =
    INTERFACE_ID( 0x5da9e47, 0x3ca6, 0x4f96, [ 0xa9, 0x67, 0x1d, 0xdd, 0xc5, 0x31, 0x81, 0xa6 ] );

/// Framebuffer description.
struct FramebufferDesc
{
    DeviceObjectAttribs _DeviceObjectAttribs;

    /// Render pass that the framebuffer will be compatible with.
    IRenderPass* pRenderPass = null;

    /// The number of attachments.
    uint AttachmentCount = 0;

    /// Pointer to the array of attachments.
    const ITextureView** ppAttachments = null;

    /// Width of the framebuffer.
    uint Width = 0;

    /// Height of the framebuffer.
    uint Height = 0;

    /// The number of array slices in the framebuffer.
    uint NumArraySlices = 0;
}

struct IFramebufferVtbl
{
    IObjectMethods       Object;
    IDeviceObjectMethods DeviceObject;
}

struct IFramebuffer { IFramebufferVtbl* pVtbl; }
