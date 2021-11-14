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

module bindbc.diligent.graphics.vulkan.renderdevicevk;

/// \file
/// Definition of the Diligent::IRenderDeviceVk interface

import bindbc.diligent.graphics.renderdevice;

// {AB8CF3A6-D959-41C1-AE00-A58AE9820E6A}
static const INTERFACE_ID IID_RenderDeviceVk =
    INTERFACE_ID(0xab8cf3a6, 0xd959, 0x41c1, [0xae, 0x0, 0xa5, 0x8a, 0xe9, 0x82, 0xe, 0x6a]);

/// Exposes Vulkan-specific functionality of a render device.
struct IRenderDeviceVkMethods
{
    /// Returns a handle of the logical Vulkan device
    VkDevice* GetVkDevice(IRenderDeviceVk*);

    /// Returns a handle of the physical Vulkan device
    VkPhysicalDevice* GetVkPhysicalDevice(IRenderDeviceVk*);

    /// Returns Vulkan instance
    VkInstance* GetVkInstance(IRenderDeviceVk*);

    /// Returns Vulkan API version

    /// \note This version is the minimum of the instance version and what the physical device supports.
    uint* GetVkVersion(IRenderDeviceVk*);

    /// Creates a texture object from native Vulkan image

    /// \param [in]  vkImage      - Vulkan image handle
    /// \param [in]  TexDesc      - Texture description. Vulkan provides no means to retrieve any
    ///                             image properties from the image handle, so complete texture
    ///                             description must be provided
    /// \param [in]  InitialState - Initial texture state. See Diligent::RESOURCE_STATE.
    /// \param [out] ppTexture    - Address of the memory location where the pointer to the
    ///                             texture interface will be stored.
    ///                             The function calls AddRef(), so that the new object will contain
    ///                             one reference.
    /// \note  Created texture object does not take ownership of the Vulkan image and will not
    ///        destroy it once released. The application must not destroy the image while it is
    ///        in use by the engine.
    void* CreateTextureFromVulkanImage(IRenderDeviceVk*,
                                                      VkImage             vkImage,
                                                      const(TextureDesc)* TexDesc,
                                                      RESOURCE_STATE      InitialState,
                                                      ITexture**          ppTexture);

    /// Creates a buffer object from native Vulkan resource

    /// \param [in] vkBuffer      - Vulkan buffer handle
    /// \param [in] BuffDesc      - Buffer description. Vulkan provides no means to retrieve any
    ///                             buffer properties from the buffer handle, so complete buffer
    ///                             description must be provided
    /// \param [in]  InitialState - Initial buffer state. See Diligent::RESOURCE_STATE.
    /// \param [out] ppBuffer     - Address of the memory location where the pointer to the
    ///                             buffer interface will be stored.
    ///                             The function calls AddRef(), so that the new object will contain
    ///                             one reference.
    /// \note  Created buffer object does not take ownership of the Vulkan buffer and will not
    ///        destroy it once released. The application must not destroy Vulkan buffer while it is
    ///        in use by the engine.
    void* CreateBufferFromVulkanResource(IRenderDeviceVk*,
                                                        VkBuffer           vkBuffer,
                                                        const(BufferDesc)* BuffDesc,
                                                        RESOURCE_STATE     InitialState,
                                                        IBuffer**          ppBuffer);
    
    /// Creates a bottom-level AS object from native Vulkan resource

    /// \param [in]  vkBLAS       - Vulkan acceleration structure handle.
    /// \param [in]  Desc         - Bottom-level AS description.
    /// \param [in]  InitialState - Initial BLAS state. Can be RESOURCE_STATE_UNKNOWN, RESOURCE_STATE_BUILD_AS_READ, RESOURCE_STATE_BUILD_AS_WRITE.
    ///                             See Diligent::RESOURCE_STATE.
    /// \param [out] ppBLAS       - Address of the memory location where the pointer to the
    ///                             bottom-level AS interface will be stored.
    ///                             The function calls AddRef(), so that the new object will contain
    ///                             one reference.
    /// \note  Created bottom-level AS object does not take ownership of the Vulkan acceleration structure and will not
    ///        destroy it once released. The application must not destroy Vulkan acceleration structure while it is
    ///        in use by the engine.
    void* CreateBLASFromVulkanResource(IRenderDeviceVk*,
                                                      VkAccelerationStructureKHR vkBLAS,
                                                      const(BottomLevelASDesc)*  Desc,
                                                      RESOURCE_STATE             InitialState,
                                                      IBottomLevelAS**           ppBLAS);
    
    /// Creates a top-level AS object from native Vulkan resource

    /// \param [in]  vkTLAS       - Vulkan acceleration structure handle.
    /// \param [in]  Desc         - Bottom-level AS description.
    /// \param [in]  InitialState - Initial TLAS state. Can be RESOURCE_STATE_UNKNOWN, RESOURCE_STATE_BUILD_AS_READ, RESOURCE_STATE_BUILD_AS_WRITE, RESOURCE_STATE_RAY_TRACING.
    ///                             See Diligent::RESOURCE_STATE.
    /// \param [out] ppTLAS       - Address of the memory location where the pointer to the
    ///                             top-level AS interface will be stored.
    ///                             The function calls AddRef(), so that the new object will contain
    ///                             one reference.
    /// \note  Created top-level AS object does not take ownership of the Vulkan acceleration structure and will not
    ///        destroy it once released. The application must not destroy Vulkan acceleration structure while it is
    ///        in use by the engine.
    void* CreateTLASFromVulkanResource(IRenderDeviceVk*,
                                                      VkAccelerationStructureKHR vkTLAS,
                                                      const(TopLevelASDesc)*     Desc,
                                                      RESOURCE_STATE             InitialState,
                                                      ITopLevelAS**              ppTLAS);
    
    /// Creates a fence object from native Vulkan resource
    
    /// \param [in]  vkTimelineSemaphore - Vulkan timeline semaphore handle.
    /// \param [in]  Desc                - Fence description.
    /// \param [out] ppFence             - Address of the memory location where the pointer to the
    ///                                    fence interface will be stored.
    ///                                    The function calls AddRef(), so that the new object will contain
    ///                                    one reference.
    /// \note  Created fence object does not take ownership of the Vulkan semaphore and will not
    ///        destroy it once released. The application must not destroy Vulkan semaphore while it is
    ///        in use by the engine.
    void* CreateFenceFromVulkanResource(IRenderDeviceVk*,
                                                       VkSemaphore         vkTimelineSemaphore,
                                                       const(FenceDesc)*   Desc,
                                                       IFence**            ppFence);
}

struct IRenderDeviceVkVtbl { IRenderDeviceVkMethods RenderDeviceVk; }
struct IRenderDeviceVk { IRenderDeviceVkVtbl* pVtbl; }

VkDevice* IRenderDeviceVk_GetVkDevice(IRenderDeviceVk* device) {
    return device.pVtbl.RenderDeviceVk.GetVkDevice(device);
}

VkPhysicalDevice* IRenderDeviceVk_GetVkPhysicalDevice(IRenderDeviceVk* device) {
    return device.pVtbl.RenderDeviceVk.GetVkPhysicalDevice(device);
}

VkInstance* IRenderDeviceVk_GetVkInstance(IRenderDeviceVk* device) {
    return device.pVtbl.RenderDeviceVk.GetVkInstance(device);
}

uint* IRenderDeviceVk_GetVkVersion(IRenderDeviceVk* device) {
    return device.pVtbl.RenderDeviceVk.GetVkVersion(device);
}

void* IRenderDeviceVk_CreateTextureFromVulkanImage(IRenderDeviceVk* device,
                                                      VkImage             vkImage,
                                                      const(TextureDesc)* texDesc,
                                                      RESOURCE_STATE      initialState,
                                                      ITexture**          ppTexture) {
    return device.pVtbl.RenderDeviceVk.CreateTextureFromVulkanImage(device, vkImage, texDesc, initialState, ppTexture);
}

void* IRenderDeviceVk_CreateBufferFromVulkanResource(IRenderDeviceVk* device,
                                                        VkBuffer           vkBuffer,
                                                        const(BufferDesc)* buffDesc,
                                                        RESOURCE_STATE     initialState,
                                                        IBuffer**          ppBuffer) {
    return device.pVtbl.RenderDeviceVk.CreateBufferFromVulkanResource(device, vkBuffer, buffDesc, initialState, ppBuffer);
}

void* IRenderDeviceVk_CreateBLASFromVulkanResource(IRenderDeviceVk* device,
                                                      VkAccelerationStructureKHR vkBLAS,
                                                      const(BottomLevelASDesc)*  desc,
                                                      RESOURCE_STATE             initialState,
                                                      IBottomLevelAS**           ppBLAS) {
    return device.pVtbl.RenderDeviceVk.CreateBLASFromVulkanResource(device, vkBLAS, desc, initialState, ppBLAS);
}

void* IRenderDeviceVk_CreateTLASFromVulkanResource(IRenderDeviceVk* device,
                                                      VkAccelerationStructureKHR vkTLAS,
                                                      const(TopLevelASDesc)*     desc,
                                                      RESOURCE_STATE             initialState,
                                                      ITopLevelAS**              ppTLAS) {
    return device.pVtbl.RenderDeviceVk.CreateTLASFromVulkanResource(device, vkTLAS, desc, initialState, ppTLAS);
}

void* IRenderDeviceVk_CreateFenceFromVulkanResource(IRenderDeviceVk* device,
                                                       VkSemaphore         vkTimelineSemaphore,
                                                       const(FenceDesc)*   desc,
                                                       IFence**            ppFence) {
    return device.pVtbl.RenderDeviceVk.CreateFenceFromVulkanResource(device, vkTimelineSemaphore, desc, ppFence);
}
