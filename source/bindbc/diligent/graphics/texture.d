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

module bindbc.diligent.graphics.engine.texture;

/// \file
/// Definition of the Diligent::ITexture interface and related data structures

import bindbc.diligent.graphics.graphicstypes;
import bindbc.diligent.graphics.deviceobject;
import bindbc.diligent.graphics.textureview;

// {A64B0E60-1B5E-4CFD-B880-663A1ADCBE98}
static const INTERFACE_ID IID_Texture =
    INTERFACE_ID(0xa64b0e60, 0x1b5e, 0x4cfd,[0xb8, 0x80, 0x66, 0x3a, 0x1a, 0xdc, 0xbe, 0x98]);

/// Texture description
struct TextureDesc
{
    DeviceObjectAttribs _DeviceObjectAttribs;

    /// Texture type. See Diligent::RESOURCE_DIMENSION for details.
    RESOURCE_DIMENSION Type = RESOURCE_DIMENSION.RESOURCE_DIM_UNDEFINED;

    /// Texture width, in pixels.
    uint Width = 0;

    /// Texture height, in pixels.
    uint Height = 0;

    union
    {
        /// For a 1D array or 2D array, number of array slices
        uint ArraySize = 1;

        /// For a 3D texture, number of depth slices
        uint Depth;
    };

    /// Texture format, see Diligent::TEXTURE_FORMAT.
    TEXTURE_FORMAT Format = TEXTURE_FORMAT.TEX_FORMAT_UNKNOWN;

    /// Number of Mip levels in the texture. Multisampled textures can only have 1 Mip level.
    /// Specify 0 to create full mipmap chain.
    uint MipLevels = 1;

    /// Number of samples.\n
    /// Only 2D textures or 2D texture arrays can be multisampled.
    uint SampleCount = 1;

    /// Texture usage. See Diligent::USAGE for details.
    USAGE Usage = USAGE.USAGE_DEFAULT;

    /// Bind flags, see Diligent::BIND_FLAGS for details. \n
    /// The following bind flags are allowed:
    /// Diligent::BIND_SHADER_RESOURCE, Diligent::BIND_RENDER_TARGET, Diligent::BIND_DEPTH_STENCIL,
    /// Diligent::and BIND_UNORDERED_ACCESS. \n
    /// Multisampled textures cannot have Diligent::BIND_UNORDERED_ACCESS flag set
    BIND_FLAGS BindFlags = BIND_FLAGS.BIND_NONE;

    /// CPU access flags or 0 if no CPU access is allowed, 
    /// see Diligent::CPU_ACCESS_FLAGS for details.
    CPU_ACCESS_FLAGS CPUAccessFlags = CPU_ACCESS_FLAGS.CPU_ACCESS_NONE;

    /// Miscellaneous flags, see Diligent::MISC_TEXTURE_FLAGS for details.
    MISC_TEXTURE_FLAGS MiscFlags = MISC_TEXTURE_FLAGS.MISC_TEXTURE_FLAG_NONE;

    /// Optimized clear value
    OptimizedClearValue ClearValue;

    /// Defines which immediate contexts are allowed to execute commands that use this texture.

    /// When ImmediateContextMask contains a bit at position n, the texture may be
    /// used in the immediate context with index n directly (see DeviceContextDesc::ContextId).
    /// It may also be used in a command list recorded by a deferred context that will be executed
    /// through that immediate context.
    ///
    /// \remarks    Only specify these bits that will indicate those immediate contexts where the texture
    ///             will actually be used. Do not set unncessary bits as this will result in extra overhead.
    ulong ImmediateContextMask = 1;

}

/// Describes data for one subresource
struct TextureSubResData
{
    /// Pointer to the subresource data in CPU memory.
    /// If provided, pSrcBuffer must be null
    const(void)* pData = null;

    /// Pointer to the GPU buffer that contains subresource data.
    /// If provided, pData must be null
    IBuffer* pSrcBuffer = null;

    /// When updating data from the buffer (pSrcBuffer is not null),
    /// offset from the beginning of the buffer to the data start
    uint SrcOffset = 0;

    /// For 2D and 3D textures, row stride in bytes
    uint Stride = 0;

    /// For 3D textures, depth slice stride in bytes
    /// \note On OpenGL, this must be a multiple of Stride
    uint DepthStride = 0;
}

/// Describes the initial data to store in the texture
struct TextureData
{
    /// Pointer to the array of the TextureSubResData elements containing
    /// information about each subresource.
    TextureSubResData* pSubResources = null;

    /// Number of elements in pSubResources array.
    /// NumSubresources must exactly match the number
    /// of subresources in the texture. Otherwise an error
    /// occurs.
    uint NumSubresources = 0;

    /// Defines which device context will be used to initialize the texture.

    /// The texture will be in write state after the initialization.
    /// If an application uses the texture in another context afterwards, it
    /// must synchronize the access to the texture using fence.
    /// When null is provided, the first context enabled by ImmediateContextMask
    /// will be used.
    IDeviceContext* pContext = null;
}

struct MappedTextureSubresource
{
    void*  pData = null;
    uint Stride = 0;
    uint DepthStride = 0;
}

/// Texture interface
struct ITextureMethods
{
    /// Creates a new texture view

    /// \param [in] ViewDesc - View description. See Diligent::TextureViewDesc for details.
    /// \param [out] ppView - Address of the memory location where the pointer to the view interface will be written to.
    /// 
    /// \remarks To create a shader resource view addressing the entire texture, set only TextureViewDesc::ViewType 
    ///          member of the ViewDesc parameter to Diligent::TEXTURE_VIEW_SHADER_RESOURCE and leave all other 
    ///          members in their default values. Using the same method, you can create render target or depth stencil
    ///          view addressing the largest mip level.\n
    ///          If texture view format is Diligent::TEX_FORMAT_UNKNOWN, the view format will match the texture format.\n
    ///          If texture view type is Diligent::TEXTURE_VIEW_UNDEFINED, the type will match the texture type.\n
    ///          If the number of mip levels is 0, and the view type is shader resource, the view will address all mip levels.
    ///          For other view types it will address one mip level.\n
    ///          If the number of slices is 0, all slices from FirstArraySlice or FirstDepthSlice will be referenced by the view.
    ///          For non-array textures, the only allowed values for the number of slices are 0 and 1.\n
    ///          Texture view will contain strong reference to the texture, so the texture will not be destroyed
    ///          until all views are released.\n
    ///          The function calls AddRef() for the created interface, so it must be released by
    ///          a call to Release() when it is no longer needed.
    void* CreateView(ITexture*, const(TextureViewDesc)* ViewDesc, ITextureView** ppView);

    /// Returns the pointer to the default view.
    
    /// \param [in] ViewType - Type of the requested view. See Diligent::TEXTURE_VIEW_TYPE.
    /// \return Pointer to the interface
    ///
    /// \note The function does not increase the reference counter for the returned interface, so
    ///       Release() must *NOT* be called.
    ITextureView** GetDefaultView(ITexture*, TEXTURE_VIEW_TYPE ViewType);

    /// Returns native texture handle specific to the underlying graphics API

    /// \return pointer to ID3D11Resource interface, for D3D11 implementation\n
    ///         pointer to ID3D12Resource interface, for D3D12 implementation\n
    ///         GL buffer handle, for GL implementation
    void** GetNativeHandle(ITexture*);

    /// Sets the usage state for all texture subresources.

    /// \note This method does not perform state transition, but
    ///       resets the internal texture state to the given value.
    ///       This method should be used after the application finished
    ///       manually managing the texture state and wants to hand over
    ///       state management back to the engine.
    void* SetState(ITexture*, RESOURCE_STATE State);

    /// Returns the internal texture state
    RESOURCE_STATE* GetState(ITexture*);
}

struct ITextureVtbl { ITextureMethods Texture; }
struct ITexture { ITextureVtbl* pVtbl; }

TextureDesc* ITexture_GetDesc(ITexture* object) {
    cast(const(TextureDesc)*)IDeviceObject_GetDesc(object);
}

void* ITexture_CreateView(ITexture* texture, const(TextureViewDesc)* viewDesc, ITextureView** ppView) {
    return texture.pVtbl.Texture.CreateView(texture, viewDesc, ppView);
}

ITextureView** ITexture_GetDefaultView(ITexture* texture, TEXTURE_VIEW_TYPE viewType) {
    return texture.pVtbl.Texture.GetDefaultView(texture, viewType);
}

void** ITexture_GetNativeHandle(ITexture* texture) {
    return texture.pVtbl.Texture.GetNativeHandle(texture);
}

void* ITexture_SetState(ITexture* texture, RESOURCE_STATE state) {
    return texture.pVtbl.Texture.SetState(texture, state);
}

RESOURCE_STATE* ITexture_GetState(ITexture* texture){
    return texture.pVtbl.Texture.GetState(texture);
}
