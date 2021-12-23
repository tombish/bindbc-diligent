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

module bindbc.diligent.graphics.vulkan.bottomlevelasvk;

import erupted;

/// \file
/// Definition of the Diligent::IBottomLevelASVk interface

import bindbc.diligent.graphics.bottomlevelas;

// {7212AFC9-02E2-4D7F-81A8-1CE5353CEA2D}
static const INTERFACE_ID IID_BottomLevelASVk =
    INTERFACE_ID(0x7212afc9, 0x2e2, 0x4d7f, [0x81, 0xa8, 0x1c, 0xe5, 0x35, 0x3c, 0xea, 0x2d]);

/// Exposes Vulkan-specific functionality of a Bottom-level acceleration structure object.
struct IBottomLevelASVkMethods
{
    /// Returns a Vulkan handle of the internal BLAS object.
    VkAccelerationStructureKHR* GetVkBLAS(IBottomLevelASVk*);

    /// Returns a Vulkan device address of the internal BLAS object.
    VkDeviceAddress* GetVkDeviceAddress(IBottomLevelASVk*);
}

struct IBottomLevelASVkVtbl { IBottomLevelASVkMethods BottomLevelASVk; }
struct IBottomLevelASVk { IBottomLevelASVkVtbl* pVtbl; }

VkAccelerationStructureKHR* IBottomLevelASVk_GetVkBLAS(IBottomLevelASVk* bottomAS) {
    return bottomAS.pVtbl.BottomLevelASVk.GetVkBLAS(bottomAS);
}

VkDeviceAddress* IBottomLevelASVk_GetVkDeviceAddress(IBottomLevelASVk* bottomAS) {
    return bottomAS.pVtbl.BottomLevelASVk.GetVkDeviceAddress(bottomAS);
}
