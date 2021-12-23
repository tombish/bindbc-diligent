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

module bindbc.diligent.graphics.vulkan.textureviewvk;

/// \file
/// Definition of the Diligent::ITextureViewVk interface

import bindbc.diligent.graphics.textureview;

import erupted;

// {B02AA468-3328-46F3-9777-55E97BF6C86E}
static const INTERFACE_ID IID_TextureViewVk =
    INTERFACE_ID(0xb02aa468, 0x3328, 0x46f3, [0x97, 0x77, 0x55, 0xe9, 0x7b, 0xf6, 0xc8, 0x6e]);

/// Exposes Vulkan-specific functionality of a texture view object.
struct ITextureViewVkMethods
{
    /// Returns Vulkan image view handle
    VkImageView* GetVulkanImageView(ITextureViewVk*);
}

struct ITextureViewVkVtbl { ITextureViewVkMethods TextureViewVk; }
struct ITextureViewVk { ITextureViewVkVtbl* pVtbl; }

VkImageView* ITextureViewVk_GetVulkanImageView(ITextureViewVk* textureView) {
    return textureView.pVtbl.TextureViewVk.GetVulkanImageView(textureView);
}