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

module bindbc.diligent.graphics.vulkan.shaderbindingtablevk;

/// \file
/// Definition of the Diligent::IShaderBindingTableVk interface

import bindbc.diligent.graphics.shaderbindingtable;
import bindbc.diligent.graphics.vulkan.devicecontextvk;

import erupted;

// {31ED9B4B-4FF4-44D8-AE71-12B5D8AF7F93}
static const INTERFACE_ID IID_ShaderBindingTableVk =
    INTERFACE_ID(0x31ed9b4b, 0x4ff4, 0x44d8, [0xae, 0x71, 0x12, 0xb5, 0xd8, 0xaf, 0x7f, 0x93]);

/// This structure contains the data that can be used as input arguments for vkCmdTraceRaysKHR() command.
struct BindingTableVk
{
    VkStridedDeviceAddressRegionKHR RaygenShader   = {};
    VkStridedDeviceAddressRegionKHR MissShader     = {};
    VkStridedDeviceAddressRegionKHR HitShader      = {};
    VkStridedDeviceAddressRegionKHR CallableShader = {};
}

/// Exposes Vulkan-specific functionality of a Shader binding table object.
struct IShaderBindingTableVkMethods
{
    /// Returns the data that can be used with vkCmdTraceRaysKHR() call.
    /// 
    /// \remarks  The method is not thread-safe. An application must externally synchronize the access
    ///           to the shader binding table.
    const(BindingTableVk)** GetVkBindingTable(IShaderBindingTableVk*);
}

struct IShaderBindingTableVkVtbl { IShaderBindingTableVkMethods ShaderBindingTableVk; }
struct IShaderBindingTableVk { IShaderBindingTableVkVtbl* pVtbl; }

const(BindingTableVk)** IShaderBindingTableVk_GetVkBindingTable(IShaderBindingTableVk* bindingTable) {
    return bindingTable.pVtbl.ShaderBindingTableVk.GetVkBindingTable(bindingTable);
}