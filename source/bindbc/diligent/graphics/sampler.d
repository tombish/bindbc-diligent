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

module bindbc.diligent.graphics.sampler;

/// \file
/// Definition of the Diligent::ISampler interface and related data structures

public import bindbc.diligent.graphics.deviceobject;

// {595A59BF-FA81-4855-BC5E-C0E048745A95}
static const INTERFACE_ID IID_Sampler =
    INTERFACE_ID(0x595a59bf, 0xfa81, 0x4855, [0xbc, 0x5e, 0xc0, 0xe0, 0x48, 0x74, 0x5a, 0x95]);

/// Sampler description

/// This structure describes the sampler state which is used in a call to
/// IRenderDevice::CreateSampler() to create a sampler object.
///
/// To create an anisotropic filter, all three filters must either be Diligent::FILTER_TYPE_ANISOTROPIC
/// or Diligent::FILTER_TYPE_COMPARISON_ANISOTROPIC.
///
/// MipFilter cannot be comparison filter except for Diligent::FILTER_TYPE_ANISOTROPIC if all
/// three filters have that value.
///
/// Both MinFilter and MagFilter must either be regular filters or comparison filters.
/// Mixing comparison and regular filters is an error.
struct SamplerDesc
{
    DeviceObjectAttribs _DeviceObjectAttribs;

    /// Texture minification filter, see Diligent::FILTER_TYPE for details.
    /// Default value: Diligent::FILTER_TYPE_LINEAR.
    FILTER_TYPE MinFilter = FILTER_TYPE.FILTER_TYPE_LINEAR;
    
    /// Texture magnification filter, see Diligent::FILTER_TYPE for details.
    /// Default value: Diligent::FILTER_TYPE_LINEAR.
    FILTER_TYPE MagFilter = FILTER_TYPE.FILTER_TYPE_LINEAR;

    /// Mip filter, see Diligent::FILTER_TYPE for details. 
    /// Only FILTER_TYPE_POINT, FILTER_TYPE_LINEAR, FILTER_TYPE_ANISOTROPIC, and 
    /// FILTER_TYPE_COMPARISON_ANISOTROPIC are allowed.
    /// Default value: Diligent::FILTER_TYPE_LINEAR.
    FILTER_TYPE MipFilter = FILTER_TYPE.FILTER_TYPE_LINEAR;

    /// Texture address mode for U coordinate, see Diligent::TEXTURE_ADDRESS_MODE for details
    /// Default value: Diligent::TEXTURE_ADDRESS_CLAMP.
    TEXTURE_ADDRESS_MODE AddressU = TEXTURE_ADDRESS_MODE.TEXTURE_ADDRESS_CLAMP;
    
    /// Texture address mode for V coordinate, see Diligent::TEXTURE_ADDRESS_MODE for details
    /// Default value: Diligent::TEXTURE_ADDRESS_CLAMP.
    TEXTURE_ADDRESS_MODE AddressV = TEXTURE_ADDRESS_MODE.TEXTURE_ADDRESS_CLAMP;

    /// Texture address mode for W coordinate, see Diligent::TEXTURE_ADDRESS_MODE for details
    /// Default value: Diligent::TEXTURE_ADDRESS_CLAMP.
    TEXTURE_ADDRESS_MODE AddressW = TEXTURE_ADDRESS_MODE.TEXTURE_ADDRESS_CLAMP;

    /// Offset from the calculated mipmap level. For example, if a sampler calculates that a texture 
    /// should be sampled at mipmap level 1.2 and MipLODBias is 2.3, then the texture will be sampled at 
    /// mipmap level 3.5. Default value: 0.
    float MipLODBias = 0;

    /// Maximum anisotropy level for the anisotropic filter. Default value: 0.
    uint MaxAnisotropy = 0;

    /// A function that compares sampled data against existing sampled data when comparison
    /// filter is used. Default value: Diligent::COMPARISON_FUNC_NEVER.
    COMPARISON_FUNCTION ComparisonFunc = COMPARISON_FUNCTION.COMPARISON_FUNC_NEVER;

    /// Border color to use if TEXTURE_ADDRESS_BORDER is specified for AddressU, AddressV, or AddressW. 
    /// Default value: {0,0,0,0}
    float[4] BorderColor = [0.0f, 0.0f, 0.0f, 0.0f];

    /// Specifies the minimum value that LOD is clamped to before accessing the texture MIP levels.
    /// Must be less than or equal to MaxLOD.
    /// Default value: 0.
    float MinLOD = 0;

    /// Specifies the maximum value that LOD is clamped to before accessing the texture MIP levels.
    /// Must be greater than or equal to MinLOD.
    /// Default value: +FLT_MAX.
    float MaxLOD = +3.402823466e+38F;

}

struct ISamplerVtbl {}
struct ISampler { ISamplerVtbl* pVtbl; }

const(SamplerDesc)* ISampler_GetDesc(ISampler* object) {
    return cast(const(SamplerDesc)*)IDeviceObject_GetDesc(cast(IDeviceObject*)object);
}
