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

module bindbc.diligent.graphics.vulkan.devicecontextvk;

/// \file
/// Definition of the Diligent::IDeviceContextVk interface

public import bindbc.diligent.graphics.devicecontext;
import bindbc.diligent.graphics.vulkan.commandqueuevk;

import erupted;

// {72AEB1BA-C6AD-42EC-8811-7ED9C72176BB}
static const INTERFACE_ID IID_DeviceContextVk =
    INTERFACE_ID(0x72aeb1ba, 0xc6ad, 0x42ec, [0x88, 0x11, 0x7e, 0xd9, 0xc7, 0x21, 0x76, 0xbb]);

/// Exposes Vulkan-specific functionality of a device context.
struct IDeviceContextVkMethods
{
    /// Transitions the internal Vulkan image to the specified layout

    /// \param [in] pTexture  - texture to transition
    /// \param [in] NewLayout - Vulkan image layout this texture to transition to
    /// \remarks The texture state must be known to the engine.
    void* TransitionImageLayout(IDeviceContextVk*, ITexture* pTexture, VkImageLayout NewLayout);

    /// Transitions the internal Vulkan buffer object to the specified state

    /// \param [in] pBuffer        - Buffer to transition
    /// \param [in] NewAccessFlags - Access flags to set for the buffer
    /// \remarks The buffer state must be known to the engine.
    void* BufferMemoryBarrier(IDeviceContextVk*, IBuffer* pBuffer, VkAccessFlags NewAccessFlags);

    /// Returns the Vulkan handle of the command buffer currently being recorded

    /// \return - handle to the current command buffer
    ///
    /// \remarks  Any command on the device context may potentially submit the command buffer for
    ///           execution into the command queue and make it invalid. An application should
    ///           never cache the handle and should instead request the command buffer every time it
    ///           needs it.
    ///
    ///           Diligent Engine internally keeps track of all resource state changes (vertex and index
    ///           buffers, pipeline states, render targets, etc.). If an application changes any of these
    ///           states in the command buffer, it must invalidate the engine's internal state tracking by
    ///           calling IDeviceContext::InvalidateState() and then manually restore all required states via
    ///           appropriate Diligent API calls.
    VkCommandBuffer* GetVkCommandBuffer(IDeviceContextVk*);
}

struct IDeviceContextVkVtbl { IDeviceContextVkMethods DeviceContextVk; }
struct IDeviceContextVk { IDeviceContextVkVtbl* pVtbl; }

void* IDeviceContextVk_TransitionImageLayout(IDeviceContextVk* context, ITexture* pTexture, VkImageLayout newLayout) {
    return context.pVtbl.DeviceContextVk.TransitionImageLayout(context, pTexture, newLayout);
}

void* IDeviceContextVk_BufferMemoryBarrier(IDeviceContextVk* context, IBuffer* pBuffer, VkAccessFlags newAccessFlags) {
    return context.pVtbl.DeviceContextVk.BufferMemoryBarrier(context, pBuffer, newAccessFlags);
}

VkCommandBuffer* IDeviceContextVk_GetVkCommandBuffer(IDeviceContextVk* context) {
    return context.pVtbl.DeviceContextVk.GetVkCommandBuffer(context);
}
