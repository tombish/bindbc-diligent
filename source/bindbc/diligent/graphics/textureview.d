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

module bindbc.diligent.graphics.textureview;

/// \file
/// Definition of the Diligent::ITextureView interface and related data structures

public import bindbc.diligent.graphics.deviceobject;
public import bindbc.diligent.graphics.texture;

struct ISampler;

// {5B2EA04E-8128-45E4-AA4D-6DC7E70DC424}
static const INTERFACE_ID IID_TextureView =
    INTERFACE_ID(0x5b2ea04e, 0x8128, 0x45e4,[0xaa, 0x4d, 0x6d, 0xc7, 0xe7, 0xd, 0xc4, 0x24]);

/// Describes allowed unordered access view mode
enum UAV_ACCESS_FLAG : ubyte
{
    /// Access mode is unspecified
    UAV_ACCESS_UNSPECIFIED = 0x00,
    
    /// Allow read operations on the UAV
    UAV_ACCESS_FLAG_READ   = 0x01,

    /// Allow write operations on the UAV
    UAV_ACCESS_FLAG_WRITE  = 0x02,

    /// Allow read and write operations on the UAV
    UAV_ACCESS_FLAG_READ_WRITE = UAV_ACCESS_FLAG_READ | UAV_ACCESS_FLAG_WRITE
}

/// Texture view flags
enum TEXTURE_VIEW_FLAGS : ubyte
{
    /// No flags
    TEXTURE_VIEW_FLAG_NONE                      = 0x00,

    /// Allow automatic mipmap generation for this view.
    /// This flag is only allowed for TEXTURE_VIEW_SHADER_RESOURCE view type.
    /// The texture must be created with MISC_TEXTURE_FLAG_GENERATE_MIPS flag.
    TEXTURE_VIEW_FLAG_ALLOW_MIP_MAP_GENERATION = 0x01,
}

/// Texture view description
struct TextureViewDesc
{
    DeviceObjectAttribs _DeviceObjectAttribs;

    /// Describes the texture view type, see Diligent::TEXTURE_VIEW_TYPE for details.
    TEXTURE_VIEW_TYPE ViewType = TEXTURE_VIEW_TYPE.TEXTURE_VIEW_UNDEFINED;

    /// View interpretation of the original texture. For instance,
    /// one slice of a 2D texture array can be viewed as a 2D texture.
    /// See Diligent::RESOURCE_DIMENSION for a list of texture types.
    /// If default value Diligent::RESOURCE_DIM_UNDEFINED is provided,
    /// the view type will match the type of the referenced texture.
    RESOURCE_DIMENSION TextureDim = RESOURCE_DIMENSION.RESOURCE_DIM_UNDEFINED;

    /// View format. If default value Diligent::TEX_FORMAT_UNKNOWN is provided,
    /// the view format will match the referenced texture format.
    TEXTURE_FORMAT Format = TEXTURE_FORMAT.TEX_FORMAT_UNKNOWN;

    /// Most detailed mip level to use
    uint MostDetailedMip = 0;

    /// Total number of mip levels for the view of the texture.
    /// Render target and depth stencil views can address only one mip level.
    /// If 0 is provided, then for a shader resource view all mip levels will be
    /// referenced, and for a render target or a depth stencil view, one mip level
    /// will be referenced.
    uint NumMipLevels = 0;

    union
    {
        /// For a texture array, first array slice to address in the view
        uint FirstArraySlice = 0;

        /// For a 3D texture, first depth slice to address the view
        uint FirstDepthSlice;
    };

    union
    {
        /// For a texture array, number of array slices to address in the view.
        /// Set to 0 to address all array slices.
        uint NumArraySlices = 0;

        /// For a 3D texture, number of depth slices to address in the view
        /// Set to 0 to address all depth slices.
        uint NumDepthSlices;
    };

    /// For an unordered access view, allowed access flags. See Diligent::UAV_ACCESS_FLAG
    /// for details.
    UAV_ACCESS_FLAG AccessFlags = UAV_ACCESS_FLAG.UAV_ACCESS_UNSPECIFIED;

    /// Texture view flags, see Diligent::TEXTURE_VIEW_FLAGS.
    TEXTURE_VIEW_FLAGS Flags = TEXTURE_VIEW_FLAGS.TEXTURE_VIEW_FLAG_NONE;
}

/// Texture view interface

/// \remarks
/// To create a texture view, call ITexture::CreateView().
/// Texture view holds strong references to the texture. The texture
/// will not be destroyed until all views are released.
/// The texture view will also keep a strong reference to the texture sampler,
/// if any is set.
struct ITextureViewMethods
{
    /// Sets the texture sampler to use for filtering operations
    /// when accessing a texture from shaders. Only
    /// shader resource views can be assigned a sampler.
    /// The view will keep strong reference to the sampler.
    void* SetSampler(ITextureView*, ISampler* pSampler);

    /// Returns the pointer to the sampler object set by the ITextureView::SetSampler().

    /// The method does *NOT* increment the reference counter of the returned object,
    /// so Release() must not be called.
    ISampler** GetSampler(ITextureView*);

    /// Returns the pointer to the referenced texture object.

    /// The method does *NOT* increment the reference counter of the returned object,
    /// so Release() must not be called.
    ITexture** GetTexture(ITextureView*);
}

struct ITextureViewVtbl { ITextureViewMethods TextureView; }
struct ITextureView { ITextureViewVtbl* pVtbl; }

const(TextureViewDesc)* ITextureView_GetDesc(ITextureView* object) {
    return cast(const(TextureViewDesc)*)IDeviceObject_GetDesc(cast(IDeviceObject*)object);
}

void* ITextureView_SetSampler(ITextureView* textureView, ISampler* pSampler) {
    return textureView.pVtbl.TextureView.SetSampler(textureView, pSampler);
}

ISampler** ITextureView_GetSampler(ITextureView* textureView) {
    return textureView.pVtbl.TextureView.GetSampler(textureView);
}

ITexture** ITextureView_GetTexture(ITextureView* textureView) {
    return textureView.pVtbl.TextureView.GetTexture(textureView);
}