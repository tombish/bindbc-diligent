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

module bindbc.diligent.graphics.vulkan.buffervk;

/// \file
/// Definition of the Diligent::IBufferVk interface

import bindbc.diligent.graphics.buffer;

import erupted;

// {12D8EC02-96F4-431E-9695-C5F572CC7587}
static const INTERFACE_ID IID_BufferVk =
    INTERFACE_ID(0x12d8ec02, 0x96f4, 0x431e, [0x96, 0x95, 0xc5, 0xf5, 0x72, 0xcc, 0x75, 0x87]);

/// Exposes Vulkan-specific functionality of a buffer object.
struct IBufferVkMethods
{
    /// Returns a Vulkan handle of the internal buffer object.
    VkBuffer* GetVkBuffer(IBufferVk*);

    /// Sets the Vulkan access flags.

    /// \param [in] AccessFlags - Vulkan access flags to be set for this buffer
    void* SetAccessFlags(IBufferVk*, VkAccessFlags AccessFlags);

    /// If the buffer state is known to the engine (i.e. not Diligent::RESOURCE_STATE_UNKNOWN),
    /// returns Vulkan access flags corresponding to the state. If the state is unknown, returns 0.
    VkAccessFlags* GetAccessFlags(IBufferVk*);

    /// Returns a Vulkan device address of the internal buffer object.
    VkDeviceAddress* GetVkDeviceAddress(IBufferVk*);
}

struct IBufferVkVtbl { IBufferVkMethods BufferVk; }
struct IBufferVk { IBufferVkVtbl* pVtbl; }

VkBuffer* IBufferVk_GetVkBuffer(IBufferVk* buffer) {
    return buffer.pVtbl.BufferVk.GetVkBuffer(buffer);
}

void* IBufferVk_SetAccessFlags(IBufferVk* buffer, VkAccessFlags accessFlags) {
    return buffer.pVtbl.BufferVk.SetAccessFlags(buffer, accessFlags);
}

VkAccessFlags* IBufferVk_GetAccessFlags(IBufferVk* buffer) {
    return buffer.pVtbl.BufferVk.GetAccessFlags(buffer);
}

VkDeviceAddress* IBufferVk_GetVkDeviceAddress(IBufferVk* buffer) {
    return buffer.pVtbl.BufferVk.GetVkDeviceAddress(buffer);
}
